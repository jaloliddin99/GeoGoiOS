//
//  DialogBottomCancelOrder.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/08/24.
//

import SwiftUI

struct DialogBottomCancelOrder: View {
    @StateObject var viewModel = FeedbackViewModel()
    @ObservedObject var mainVm : MainViewModel
    @State private var contentSize: CGSize = .zero

    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 12){
                DialogToolBar(showDialog: $mainVm.showCancelBottomDialog, title: "Cancel Order")
                Text("Tell us why you wanted to cancel the order")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack(spacing: 4) {
                        if let feedback = viewModel.feedback {
                            ForEach(feedback) { option in
                                HStack(alignment: .center) {
                                    RadioButton(isSelected: viewModel.selectedOptionID == option.id)
                                    Text(option.title)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .padding(.leading, 12)
                                    Spacer()
                                }
                                .frame(height: 40)
                                .onTapGesture {
                                    viewModel.selectedOptionID = option.id
                                }
                            }
                        }
                    }
                }
                .safeAreaPadding(.bottom, 70)
                
                Spacer()
                
                Button(action: {
                    let feedBackPostModel = FeedBackPostModel(
                        complainent: getUserPhone(),
                        message: viewModel.selectedOptionID!,
                        orderId: "\(DataHolder.orderId)",
                        type: "toOrder"
                    )
                    viewModel.postFeedBacks(feedBackBody: feedBackPostModel)
                    
                    mainVm.showCancelBottomDialog.toggle()
                }) {
                    GGButton(title: "Confirm")
                }
                .disabled(viewModel.selectedOptionID == nil)
                .opacity(viewModel.selectedOptionID == nil ? 0.5 : 1.0)
                
            }
            .onAppear {
                viewModel.getFeedbacks()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
            if viewModel.isLoading {
                LoadingView()
            }
            
        }
        
        
    }
}
