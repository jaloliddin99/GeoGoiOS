//
//  HomeScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 27/06/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct HomeScreen: View {
    
    @StateObject var viewModel = MainViewModel()
    @State private var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.3385, longitude: 69.3346)
    
    @State private var isDrawerOpen = false
    @State private var markerOffset: CGFloat = 0
    @State private var bottomSheetShown = false
    @State private var status = 0
    
    
    var body: some View {
        let uri = StyleURI(rawValue: "mapbox://styles/uzdriver/cl0j7klhe001415o8wpkop805")!
        let cameraOptions = CameraOptions(center: viewModel.tashkent, zoom: 14, bearing: 0, pitch: 60)
        
        
        NavigationStack{
            ZStack{
                CustomMapView(markerOffset: $markerOffset,
                              currentCenterCoordinate: $location,
                              vp: cameraOptions,
                              mapStyle: uri
                )
                .ignoresSafeArea()
                .onChange(of: markerOffset) {
                    checkMarkerOffset(status: status)
                }
                
                Button(action: {
                    withAnimation {
                        isDrawerOpen.toggle()
                    }
                }) {
                    DrawerBtn()
                }
                .padding(.top, 12)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                
                
                if(status == 0){
                    MarkerView(markerOffset: $markerOffset, viewModel: viewModel)
                        .offset(y: markerOffset)
                        .animation(.easeInOut, value: markerOffset)
                    
                    BottomSheetView(isOpen: $bottomSheetShown,
                                    minHeight: 250,
                                    maxHeight: UIScreen.main.bounds.height) {
                        BottomSheetContent(status: $status, viewModel: viewModel)
                    }
                                    .edgesIgnoringSafeArea(.bottom)
                    
                }else if(status == 1){
                    OrderGoView(status: $status, mainViewModel: viewModel)
                        .onAppear {
                            viewModel.serviceTariffRequest()
                        }
                    
                }
                
                if isDrawerOpen {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }
                }
                HomeScreenDrawer(isOpen: $isDrawerOpen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .ignoresSafeArea()
                
            }
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton
                )
            }
            
        }
        
    }
    
    private func checkMarkerOffset(status: Int) {
        
        if markerOffset == 0 && status == 0 {
            viewModel.reverseLocation(lat: location.latitude, lon: location.longitude)
        }
    }
    
}
