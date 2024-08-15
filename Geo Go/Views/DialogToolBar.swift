//
//  DialogToolBar.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct DialogToolBar: View {
    @Binding var showDialog: Bool
    let title: String
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                showDialog = false
            }) {
                Image(systemName: "xmark")
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }
            
            Spacer()
            GGText(text: title)
            Spacer()
            
            Button("Done") {
                showDialog = false
            }
            .font(.system(size: 16))
            .hidden()
        }
    }
}


struct DialogToolBar_Previews: PreviewProvider {
    @State static var showDialog = false
    
    static var previews: some View {
        DialogToolBar(showDialog: $showDialog, title: "Bonus")
        .previewLayout(.sizeThatFits)
    }
}
