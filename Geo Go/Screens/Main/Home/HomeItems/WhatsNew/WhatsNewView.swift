//
//  WhatsNewView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 02/07/24.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let content: Content
    @GestureState private var translation: CGFloat = 0
    
    init(isOpen: Binding<Bool>, minHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 5)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                        .padding()
                    self.content
                }
                .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                .background(Color(.white))
                .cornerRadius(20)
                .frame(height: geometry.size.height, alignment: .bottom)
                .offset(y: calculateOffset(with: geometry))
                .animation(.interactiveSpring(), value: isOpen)
                .animation(.interactiveSpring(), value: translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            if self.isOpen && value.translation.height < 0 {
                                state = 0
                            } else {
                                state = value.translation.height
                            }
                        }
                        .onEnded { value in
                            
                            let snapDistance = self.minHeight * 0.25
                            if value.translation.height < -snapDistance {
                                withAnimation {
                                    self.isOpen = true
                                }
                            } else if value.translation.height > snapDistance {
                                withAnimation {
                                    self.isOpen = false
                                }
                            }
                        }
                )
            }
        }
    }
    private func calculateOffset(with geometry: GeometryProxy) -> CGFloat {
        let offset = isOpen ? self.maxHeight - geometry.size.height : maxHeight - minHeight
        return offset + translation
    }
}


struct BottomSheetContent: View{
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 12) {
                SearchTextView(viewModel: viewModel)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 6) {
                        ForEach(viewModel.addressHistoryResponse ?? [], id: \.id) { orderInfo in
                            ShortOrderInfoView(viewModel: viewModel, orderInfo: orderInfo)
                        }
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                }
                WhatsUpView()
                Spacer()
            }
            .padding(.bottom, 64)
        }
        
        
    }
}
