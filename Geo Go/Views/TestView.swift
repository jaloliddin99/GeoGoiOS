//
//  TestView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct EditBtn: View {
    var body: some View {
        Image(systemName: "pencil")
            .frame(width: 32, height: 32)
            .background(Circle().fill(.main))
            .foregroundColor(.white)
    }
}


struct WhatsUpView: View {
    let url = UserDefaults.standard.string(forKey: Constants.clientBody)!
    let lang = DataHolder.lang
    
    @State private var selectedStoryUrls: [String]? = nil
    @State private var showingStory = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 12){
                HStack(spacing: 12) {
                    CardView(imageName: "image_1", title: "whats_up", textColor: .white, width: 150, imageNumber:1)
                        .onTapGesture {
                            let list = [
                                "\(url)/\(lang)/cashocard/1.jpg",
                                "\(url)/\(lang)/cashocard/2.jpg",
                                "\(url)/\(lang)/cashocard/3.jpg"
                            ]
                            navigateToStory(urls: list)
                        }
                    
                    CardView(imageName: "image_2", title: "choosing_comfort", textColor: .white, width: geometry.size.width-162, imageNumber: 2)
                        .onTapGesture {
                            let list = [
                                "\(url)/\(lang)/how2selectcomford/1.jpg",
                                "\(url)/\(lang)/how2selectcomford/2.jpg",
                                "\(url)/\(lang)/how2selectcomford/3.jpg"
                            ]
                            navigateToStory(urls: list)
                        }
                }
                
                CardView(imageName: "image_3", title: "how_to_check_d", textColor: .white, width: geometry.size.width,
                         imageNumber: 2)
                .onTapGesture {
                    let list = [
                        "\(url)/\(lang)/how2search/1.jpg",
                        "\(url)/\(lang)/how2search/2.jpg",
                        "\(url)/\(lang)/how2search/3.jpg"
                    ]
                    navigateToStory(urls: list)
                }
                
                HStack(spacing: 12) {
                    FrameView(imageName: "image_4", title: "why_prices_increased", textColor: .black, width: geometry.size.width-162, bgColor: .colorWs1)
                        .onTapGesture {
                            let list = [
                                "\(url)/\(lang)/howprice2up/1.jpg",
                                "\(url)/\(lang)/howprice2up/2.jpg",
                                "\(url)/\(lang)/howprice2up/3.jpg"
                            ]
                            navigateToStory(urls: list)
                        }
                    
                    FrameView(imageName: "image_5", title: "parcel_delivery", textColor: .black, width: 150, bgColor: .colorWs2)
                        .onTapGesture {
                            let list = [
                                "\(url)/\(lang)/delivery/1.jpg",
                                "\(url)/\(lang)/delivery/2.jpg",
                                "\(url)/\(lang)/delivery/3.jpg"
                            ]
                            navigateToStory(urls: list)
                        }
                    
                }
                
                FrameView(imageName: "image_6", title: "why_card_better", textColor: .black, isCustomImage: true, width: geometry.size.width, bgColor: .colorWs3)
                    .onTapGesture {
                        let list = ["\(url)/\(lang)/how2testdriver/1.jpg",
                                    "\(url)/\(lang)/how2testdriver/2.jpg",
                                    "\(url)/\(lang)/how2testdriver/3.jpg"
                        ]
                        navigateToStory(urls: list)
                    }
            }
        }
        .frame(height: 150)
        .fullScreenCover(isPresented: $showingStory) {
            if let urls = selectedStoryUrls, !urls.isEmpty {
                StoryView(imageUrls: urls)
            } else {
                Text("No stories to show")
            }
        }
        .onChange(of: showingStory) { newValue in
            print("showingStory changed: \(newValue)")
        }
    }
    
    private func navigateToStory(urls: [String]) {
        DispatchQueue.main.async {
            selectedStoryUrls = urls
            showingStory = true
        }
    }

}

struct CardView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var width: CGFloat
    var imageNumber = 1
    
    var body: some View {
        ZStack {
            if imageNumber == 1 {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }else{
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: width, maxHeight: 135)
            }
            
            
            VStack {
                HStack {
                    Text(LocalizedStringKey(title))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(textColor)
                        .padding()
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .background(.colorWs0)
        .cornerRadius(16)
        .frame(height: 135)
    }
}


struct FrameView: View {
    var imageName: String
    var title: String
    var textColor: Color
    var isCustomImage: Bool = false
    var maxLines: Int = 2
    let width: CGFloat
    let bgColor: Color
    var body: some View {
        ZStack {
            bgColor
                .edgesIgnoringSafeArea(.all)

            Text(LocalizedStringKey(title))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(textColor)
                .lineLimit(maxLines)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            
            
            
            if isCustomImage {
                Image(imageName)
                    .resizable()
                    .frame(width: 120, height: 90)
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            }else{
                Image(imageName)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            }
                
            
        }
        .frame(height: 135)
        .background(bgColor)
        .cornerRadius(16)
        
       
    }
}

struct WhatsUpView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsUpView()
            
    }
}
