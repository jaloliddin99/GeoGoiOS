//
//  StatusDependentView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 12/11/24.
//

import SwiftUI

struct StatusDependentView: View {
    @Binding var markerOffset: CGFloat
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        switch viewModel.status {
            case 0:
                DefaultContentView(markerOffset: $markerOffset, viewModel: viewModel)
            case 1:
                OrderGoView(mainViewModel: viewModel)
                    .onAppear(perform: handleOrderGoViewAppearance)
            case 2:
                SearchDriver(viewModel: viewModel)
            case 3:
                DriverFoundView(viewModel: viewModel)
            case 4:
                DriverFoundView(viewModel: viewModel)
            case 5:
                DriverFoundView(viewModel: viewModel)
            default:
                DefaultContentView(markerOffset: $markerOffset, viewModel: viewModel)
        }
    }
    
    private func handleOrderGoViewAppearance() {
        if !viewModel.hasOrderGoViewAppeared {
            viewModel.serviceTariffRequest()
            print("Lattitude and longitudemmmm")

            viewModel.requestToDrawRoute(list: mapToRouteCoordinatesLatLng(coordinates: viewModel.locationHolder))
            viewModel.hasOrderGoViewAppeared = true
        }
    }
}
