//
//  PaymentScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct PaymentScreen: View {
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0){
                Text("Choose your default payment method")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color.txt)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                
                Divider()
                
                CheckboxView(labelText: "Cash")
                
                Divider()
                
                Button(action: {
                
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                        Text("Add Payment Card")
                            .font(.custom("Roboto-Regular", size: 18))
                            .foregroundColor(Color.txt)
                    }
                
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading)
                
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Payment Method")
        .background(.white)
        .navigationBarTitleDisplayMode(.inline)
    }
    

}

#Preview {
    PaymentScreen()
}
