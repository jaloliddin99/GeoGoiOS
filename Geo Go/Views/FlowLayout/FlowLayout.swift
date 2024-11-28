//
//  FlowLayout.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/06/24.
//

import SwiftUI

struct FlowLayout: View {
    let minWidth: CGFloat
    let spacing: CGFloat
    let items: [AnyView]

    init(minWidth: CGFloat, spacing: CGFloat, items: [AnyView]) {
        self.minWidth = minWidth
        self.spacing = spacing
        self.items = items
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry.size)
        }
    }

    private func generateContent(in size: CGSize) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(0..<items.count, id: \.self) { index in
                items[index]
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > size.width) {
                            width = 0
                            height -= lastHeight
                        }
                        let result = width
                        if index == items.count - 1 {
                            width = 0
                        } else {
                            width -= dimension.width + spacing
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        lastHeight = dimension.height
                        return result
                    })
            }
        }
    }
}

