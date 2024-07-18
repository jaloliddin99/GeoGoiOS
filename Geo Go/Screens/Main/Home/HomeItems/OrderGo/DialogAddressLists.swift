//
//  DialogAddressLists.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/07/24.
//

import SwiftUI

struct DialogAddressLists: View {
    @Binding var dialogAddressList: Bool
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            Text("Your Destinations!")
                .font(.title)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 24, leading: 12, bottom: 12, trailing: 12))

            ForEach(viewModel.locationHolder.indices, id: \.self) { index in
                let isFirstIndex = index == 0
                let isLastIndex = index == viewModel.locationHolder.count - 1
                HStack {
                    Text(viewModel.locationHolder[index].addressName)
                        .lineLimit(2)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Button(action: {
                        if !isFirstIndex && !isLastIndex {
                            viewModel.locationHolder.remove(at: index)
                        }
                    }) {
                        if isFirstIndex {
                            Image("location_pin")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(Color.green)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color.white))
                        }else if isLastIndex {
                            Image("destination_flag")
                                .resizable()
                                .foregroundColor(Color.green)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color.white))
                        }else{
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                                .background(Circle().fill(Color.white))
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal, 12)
            }
            Spacer()
            Button {
                dialogAddressList.toggle()
            } label: {
                GGButton(title: "Close")
            }
            .padding()
        }
    }
}
