//
//  StatusDependentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI

struct StatusDependentView: View {
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var socketViewModel: SocketViewModel
    
    var body: some View {
        switch viewModel.status {
            case 0:
                DefaultContentView(viewModel: viewModel)
                
            case 1:
                OrderGoView(mainViewModel: viewModel)
                    .onAppear(perform: handleOrderGoViewAppearance)
                
            case 2:
                SearchDriver(viewModel: viewModel)
            case 3:
                DriverFoundView(viewModel: viewModel, socketViewModel: socketViewModel)
            case 4:
                DriverFoundView(viewModel: viewModel, socketViewModel: socketViewModel)
            case 5:
                DriverFoundView(viewModel: viewModel, socketViewModel: socketViewModel)
            default:
                DefaultContentView(viewModel: viewModel)
        }
        
    }
    
    
    
    private func handleOrderGoViewAppearance() {
        if !viewModel.hasOrderGoViewAppeared {
            viewModel.serviceTariffRequest()
            viewModel.requestToDrawRoute(list: mapToRouteCoordinatesLatLng(coordinates: viewModel.locationHolder))
            viewModel.hasOrderGoViewAppeared = true
        }
    }
}
