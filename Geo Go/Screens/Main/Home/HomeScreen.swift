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
    @State private var selectedScreen: DestinationScreen? = nil
    
    var body: some View {
        let uri = StyleURI(rawValue: "mapbox://styles/uzdriver/cl0j7klhe001415o8wpkop805")!
        let cameraOptions = CameraOptions(center: viewModel.tashkent, zoom: 12)
        
        NavigationStack {
            ZStack {
                CustomMapView(markerOffset: $markerOffset,
                              currentCenterCoordinate: $location,
                              viewModel: viewModel,
                              vp: cameraOptions,
                              mapStyle: uri
                )
                .ignoresSafeArea()
                .onChange(of: markerOffset) {
                    checkMarkerOffset(status: viewModel.status)
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
                
                
                if viewModel.status == 0 {
                    MarkerView(markerOffset: $markerOffset, viewModel: viewModel)
                        .offset(y: markerOffset)
                        .animation(.easeInOut, value: markerOffset)
                    
                    BottomSheetView(isOpen: $viewModel.bottomSheetShown,
                                    minHeight: 250,
                                    maxHeight: UIScreen.main.bounds.height) {
                        BottomSheetContent(viewModel: viewModel)
                    }.edgesIgnoringSafeArea(.bottom)
                    
                } else if viewModel.status == 1 {
                    OrderGoView(mainViewModel: viewModel)
                        .onAppear {
                            if !viewModel.hasOrderGoViewAppeared {
                                viewModel.serviceTariffRequest()
                                viewModel.requestToDrawRoute(list: mapToRouteCoordinatesLatLng(coordinates: viewModel.locationHolder))
                                viewModel.hasOrderGoViewAppeared = true
                            }
                        }
                } else if viewModel.status == 2 {
                    SearchDriver(viewModel: viewModel)
                } else if viewModel.status == 3 || viewModel.status == 4 || viewModel.status == 5 {
                    DriverFoundView(viewModel: viewModel)
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
                
                HomeScreenDrawer(isOpen: $isDrawerOpen, selectedScreen: $selectedScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .ignoresSafeArea()
                
                    .navigationDestination(isPresented: Binding(
                        get: { selectedScreen != nil },
                        set: { isActive in
                            if !isActive {
                                selectedScreen = nil
                            }
                        }
                    )){
                        getDestinationView(for: selectedScreen ?? .myTrips, viewModel: viewModel)
                    }
                 
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: alertItem.dismissButton
                )
            }
            .alert(isPresented: $viewModel.showCancelOrderAlert) {
                Alert(
                    title: Text("Cancel Order"),
                    message: Text("Are you sure you want to cancel the order?"),
                    primaryButton: .destructive(Text("Cancel Order")) {
                        viewModel.cancelMyOrder()
                    },
                    secondaryButton: .cancel(Text("Continue")) {
                        viewModel.showCancelOrderAlert.toggle()
                    }
                )
            }
            .sheet(isPresented: $viewModel.isSearchDialogShowing) {
                BottomSheet {
                    SearchScreenDialog(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.isShowBonusDialog) {
                BottomSheet {
                    DialogSelectBonus(viewModel: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.showCancelBottomDialog) {
                BottomSheet {
                    DialogBottomCancelOrder(mainVm: viewModel)
                }
            }
            .sheet(isPresented: $viewModel.showRateDriver) {
                BottomSheet {
                    DialogRateDriver(invokeDialog: $viewModel.showRateDriver) { action in }
                }
            }
            .sheet(isPresented: $viewModel.showTariffDetailsDialog) {
                VStack {
                    TariffDetailsView(item: DataHolder.selectedTariff!)
                }
            }
        }
    }
    
    private func checkMarkerOffset(status: Int) {
        if markerOffset == 0 && status == 0 {
            viewModel.reverseLocation(lat: location.latitude, lon: location.longitude)
        }
    }
    
    private func getDestinationView(for destination: DestinationScreen, viewModel: MainViewModel) -> some View {
        switch destination {
            case .myTrips:
                return AnyView(MyTripsScreen(viewModel: viewModel))
            case .paymentMethod:
                return AnyView(PaymentScreen())
            case .favouriteAddresses:
                return AnyView(FavScreen())
            case .loyaltyProgram:
                return AnyView(LoyaltyScreen())
            case .discount:
                return AnyView(DiscountScreen())
            case .settings:
                return AnyView(SettingsScreen())
            case .news:
                return AnyView(NewsScreen())
            case .support:
                return AnyView(SupportScreen())
            case .aboutApp:
                return AnyView(AboutAppScreen())
        }
    }

}
