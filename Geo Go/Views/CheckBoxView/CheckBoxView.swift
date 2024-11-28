//
//  CheckBoxView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 20/08/24.
//

import SwiftUI



struct CheckboxView: View {
    @State private var isChecked: Bool = true
    var labelText: String
    
    var body: some View {
        HStack(spacing: 12) {
            Toggle(isOn: $isChecked) {
                Text(labelText)
                    .foregroundStyle(.txt)
            }
            .toggleStyle(CheckboxToggleStyle())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .primary)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    CheckboxView(labelText: "Click me")
}
