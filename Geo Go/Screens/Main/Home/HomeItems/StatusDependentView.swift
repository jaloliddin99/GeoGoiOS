//
//  StatusDependentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI

struct StatusDependentView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
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
