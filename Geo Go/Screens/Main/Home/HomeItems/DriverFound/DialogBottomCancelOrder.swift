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
        ZStack{
            VStack(alignment: .leading, spacing: 12){
                DialogToolBar(showDialog: $mainVm.showCancelBottomDialog, title: "Cancel Order")
                Text("Tell us why you canceled the order")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                
                ScrollView {
                    VStack(spacing: 4) {
                        if let feedback = viewModel.feedback {
                            ForEach(feedback) { option in
                                HStack(alignment: .center) {
                                    RadioButton(isSelected: viewModel.selectedOptionID == option.id) {
                                        viewModel.selectedOptionID = option.id
                                    }
                                    Text(option.title)
                                        .foregroundColor(.black)
                                        .lineLimit(2)
                                        .padding(.leading, 12)
                                    Spacer()
                                }
                                .frame(height: 40)
                            }
                        }
                    }
                }
                .safeAreaPadding(.bottom, 70)
                
                
                Button(action: {
                    let phone: String = UserDefaults.standard.string(forKey: Constants.USER_PHONE) ?? "+998994522399"
                    let feedBackPostModel = FeedBackPostModel(
                        complainent: phone,
                        message: viewModel.selectedOptionID!,
                        orderId: DataHolder.orderId,
                        type: "toOrder"
                    )
                    viewModel.postFeedBacks(feedBackBody: feedBackPostModel)
                }) {
                    GGButton(title: "Confirm")
                }
                .disabled(viewModel.selectedOptionID == nil)
                .opacity(viewModel.selectedOptionID == nil ? 0.5 : 1.0)
                
            }
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton
                )
            }
            .onAppear {
                viewModel.getFeedbacks()
            }
            .onReceive(viewModel.$feedbackResponse) { newValue in
                if newValue != nil {
                    mainVm.showCancelBottomDialog.toggle()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            
        }
        
        if viewModel.isLoading {
            LoadingView()
        }
    }
}
