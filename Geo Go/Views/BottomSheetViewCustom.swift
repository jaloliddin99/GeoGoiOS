//
//  BottomSheetViewCustom.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 15/11/24.
//

import SwiftUI
import SwiftUI

fileprivate enum ConstantsValue {
    static let radius: CGFloat = 20
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheetViewCustom<Content: View>: View {
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: ConstantsValue.radius)
            .fill(Color.secondary)
            .frame(
                width: ConstantsValue.indicatorWidth,
                height: ConstantsValue.indicatorHeight
            ).onTapGesture {
                self.isOpen.toggle()
            }
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.white))
            .cornerRadius(ConstantsValue.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * ConstantsValue.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

