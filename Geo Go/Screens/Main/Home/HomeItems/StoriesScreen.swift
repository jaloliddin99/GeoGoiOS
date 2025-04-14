//
//  StoriesScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 01/04/25.
//

import SwiftUI
import Combine

struct StoryView: View {
    let imageUrls: [String]
    @State private var currentIndex = 0
    @State private var progress: Double = 0.0
    @State private var timer: AnyCancellable?
    @State private var startTime: Date = Date()
    @State private var isCurrentImageLoaded = false
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGFloat = 0

    private let storyDuration: Double = 10.0
    
    var body: some View {
        ZStack {
            if !imageUrls.isEmpty {
                StoryImageView(imageUrl: imageUrls[currentIndex], isLoaded: $isCurrentImageLoaded)
                    .edgesIgnoringSafeArea(.all)
                    .onChange(of:isCurrentImageLoaded) { newValue in
                        if newValue {
                            startTimer()
                        } else {
                            pauseTimer()
                        }
                    }
            }
            
            VStack {
                HStack(spacing: 4) {
                    ForEach(0..<imageUrls.count, id: \.self) { index in
                        ProgressBar(
                            progress: index < currentIndex ? 1.0 :
                                (index == currentIndex ? progress : 0.0)
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 64)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
                HStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentIndex > 0 {
                                currentIndex -= 1
                                resetProgress()
                                isCurrentImageLoaded = false
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 3)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .frame(width: UIScreen.main.bounds.width / 3)
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if currentIndex < imageUrls.count - 1 {
                                currentIndex += 1
                                resetProgress()
                                isCurrentImageLoaded = false
                            }else{
                                timer?.cancel()
                                dismiss()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width / 3)
                }
            }
        }
        .offset(y: dragOffset) // Apply swipe effect
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height > 0 { // Detect downward swipe
                        dragOffset = gesture.translation.height
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.height > 100 { // If swipe is significant, dismiss
                        dismiss()
                    } else {
                        dragOffset = 0 // Reset position if swipe is not strong enough
                    }
                }
        )

        .onDisappear {
            timer?.cancel()
        }
    }
    
    private func startTimer() {
        timer?.cancel()
        
        resetProgress()
        
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if  isCurrentImageLoaded {
                    let elapsedTime = Date().timeIntervalSince(startTime)
                    progress = min(elapsedTime / storyDuration, 1.0)
                    
                    if progress >= 1.0 {
                        if currentIndex < imageUrls.count - 1 {
                            currentIndex += 1
                            resetProgress()
                            isCurrentImageLoaded = false
                            
                        } else {
                            timer?.cancel()
                            dismiss()
                        }
                    }
                }
            }
    }
    
    private func resetProgress() {
        progress = 0.0
        startTime = Date()
    }
    
    private func pauseTimer() {
        // We don't cancel the timer, just set a flag to pause progress updates
    }
}

struct StoryImageView: View {
    let imageUrl: String
    @Binding var isLoaded: Bool
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                Color.black
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        
                }
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: imageUrl) { newUrl in
            image = nil
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        isLoaded = false
        
        guard let url = URL(string: imageUrl) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let data = data, let loadedImage = UIImage(data: data) {
                    self.image = loadedImage
                    self.isLoaded = true
                }
            }
        }.resume()
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .frame(width: geometry.size.width, height: 3)
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width * CGFloat(progress), height: 3)
            }
        }
        .frame(height: 3)
    }
}

// Example usage
struct ContentView: View {
    let exampleImageUrls = [
        "https://example.com/image2.jpg",
        "https://example.com/image3.jpg",
        "https://example.com/image4.jpg"
    ]
    
    var body: some View {
        StoryView(imageUrls: exampleImageUrls)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
