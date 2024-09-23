//
//  OTPView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 17/09/24.
//

import SwiftUI
import Combine
struct OTPField: View {
    
    private enum FocusField: Hashable {
        case otpField
    }
    @FocusState private var focusedField: FocusField?
    
    @Binding var otpCode: String
    private let otpCodeLength: Int
    
    init(_ otpCode: Binding<String>, otpCodeLength: Int = 6) {
        self._otpCode = otpCode
        self.otpCodeLength = min(max(otpCodeLength, 1), 8)
    }
    
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                HStack (spacing: 8) {
                    ForEach(0..<6) { index in
                        otpText(text: otpDigit(at: index))
                            .foregroundStyle(otpCode.count == index ? Color.accentColor : Color.secondary)
                    }
                }
                
                TextField("", text: $otpCode)
                    .frame(width: 0, height: 0)
                    .textContentType(.oneTimeCode)
                    .focused($focusedField, equals: .otpField)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .background(Color.clear)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .onChange(of: otpCode, { oldValue, newValue in
                        let filteredValue = newValue.filter { $0.isNumber }
                        otpCode = String(filteredValue.prefix(6))
                        print(newValue)
                    })
                
            }
        }
        .onAppear {
            self.focusedField = .otpField
        }
    }
    
    private func otpText(text: String) -> some View {
        let digit = text.filter { $0.isNumber }
        return Text(digit)
            .font(.title)
            .foregroundStyle(.primary)
            .frame(width: 48, height: 48)
            .overlay(RoundedRectangle(cornerRadius: 16).frame(width: nil, height: 2, alignment: .bottom), alignment: .bottom)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = .otpField
            }
    }
    
    private  func otpDigit(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        return String(Array(otpCode)[index])
    }
}
