//
//  StatusDependentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI
struct StatusDependentView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        Group {
            if (viewModel.status == 0 || viewModel.status == 1) && viewModel.serviceNotAvailable {
                //viewModel.markerOffset
                AppNotWorkScreen(viewModel: viewModel)
            } else {
                switch viewModel.status {
                    case 0:
                        DefaultContentView(viewModel: viewModel)
                    case 1:
                        OrderGoView(mainViewModel: viewModel)
                    case 2:
                        SearchDriver(viewModel: viewModel)
                    case 3:
                        DriverFoundView(viewModel: viewModel)
                    case 4:
                        DriverFoundView(viewModel: viewModel)
                    case 5:
                        DriverFoundView(viewModel: viewModel)
                    default:
                        DefaultContentView(viewModel: viewModel)
                }
            }
        }
        .onChange(of: viewModel.status) { _, _ in
            updateBottomSheetVisibility()
        }
        .onChange(of: viewModel.serviceNotAvailable) { _, _ in
            updateBottomSheetVisibility()
        }
        .onAppear {
            updateBottomSheetVisibility()
        }
    }
    
    private func updateBottomSheetVisibility() {
        showBottomSheet = (viewModel.status == 0 || viewModel.status == 1) && viewModel.serviceNotAvailable
    }
}
