//
//  FinishOrder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 07/08/24.
//

import SwiftUI

struct DialogRateDriver: View {
    
    @ObservedObject var viewModel: MainViewModel
    @Binding var invokeDialog: Bool
    let onActionCommited: (CommentAndIndex) -> Void
    @State private var comment: String = ""
    var isButtonDisabled: Bool {
        return comment.count < 4
    }
    
    
    
    
    
    var body: some View {
        VStack(spacing: 12){
            DialogToolBar(showDialog: $invokeDialog, title: "order_completed")
            
            Text("total_fare")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.txt)
                .padding(.top, 12)
            
            if let orderDetail = viewModel.getOrderDetail {
                
                Text(formatNumberWithSpaces(orderDetail.usedBonuses != nil
                                ? orderDetail.cost.amount - orderDetail.usedBonuses!
                                : orderDetail.cost.amount
                            )
                )
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, 12)
                    
                if let usedBonuses = orderDetail.usedBonuses {
                    HStack(spacing: 12){
                        
                        Text("payment_with_bonus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.txt)
                        
                        Text(formatNumberWithSpaces(usedBonuses))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.main)
                        
                    }
                    .padding(.top, 12)
                    
                }
            
                Line()
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
            }
            
            Text("rate_driver")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 12)
            
            StarRating(rating: .constant(5), maxRating: 5) { newRating in
            }
            .font(.title2)
            .padding(.vertical, 12)
        
            CommentField(comment: $comment, hint: "hint_good_driver")
            
            Spacer()
            Button(action: {
                onActionCommited(CommentAndIndex(comment: comment, star: 5))
                invokeDialog.toggle()
            }, label: {
                GGButton(title: "send")
            })
            .disabled(isButtonDisabled)
            .opacity(isButtonDisabled ? 0.5 : 1.0)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct CommentAndIndex{
    let comment: String
    let star: Int
}

