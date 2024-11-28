//
//  CustomKeyboardView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/11/24.
//

import SwiftUI
struct CustomKeyboardView: View {
    @Binding var inputText: String
    
    let keypad: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "←"]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(keypad, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { key in
                        Button(action: {
                            handleKeyPress(key: key)
                        }) {
                            Text(key)
                                .font(.title)
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .foregroundColor(.primary)
                                .background(Color.white)
                        }
                        .buttonStyle(CustomRippleButtonStyle(rippleColor: .gray.opacity(0.5)))
                        .disabled(key.isEmpty || (inputText.isEmpty && key == "0") ||
                                  (inputText.count > 5 && key != "←"))
                    }
                }
                .frame(height: 80)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func handleKeyPress(key: String) {
        if key == "←" {
            if !inputText.isEmpty {
                inputText.removeLast()
            }
        } else if !key.isEmpty {
            inputText.append(key)
        }
    }
    struct CustomRippleButtonStyle: ButtonStyle {
        let rippleColor: Color
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                    .background(.white)
                
                if configuration.isPressed {
                    Circle()
                        .fill(rippleColor)
                        .scaleEffect(1)
                        .opacity(0.5)
                }
            }
            .animation(.easeOut(duration: 1), value: configuration.isPressed)
        }
    }


}
