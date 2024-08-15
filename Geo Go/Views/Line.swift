//
//  Line.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct Line: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 1)
            .background(.gray.opacity(0.5))
            .foregroundColor(.gray.opacity(0.5))
            
    }
}

#Preview {
    Line()
}
