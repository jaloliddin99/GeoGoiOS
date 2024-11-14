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
    @StateObject var locationManager = LocationManager()
    
    @State private var isDrawerOpen = false
    @State private var markerOffset: CGFloat = 0
    @State private var selectedScreen: DestinationScreen? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapLayer
                drawerAndBonusButton()
                contentViews
                drawerLayer
            }
            .alert(item: $viewModel.alertItem, content: createAlert)
            .alert(isPresented: $viewModel.showCancelOrderAlert, content: cancelOrderAlert)
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
                    DialogRateDriver(viewModel: viewModel, invokeDialog: $viewModel.showRateDriver) { action in }
                }
            }
            .sheet(isPresented: $viewModel.showBonusDialog, content: {
                BottomSheet {
                    DialogBonus(viewModel: viewModel)
                }
            })
            .sheet(isPresented: $viewModel.showTariffDetailsDialog) {
                BottomSheet {
                    TariffDetailsView(item: DataHolder.selectedTariff!)
                }
            }
            .onAppear {
                if viewModel.status == 0 {
                    locationManager.requestLocation()
                }
            }
            .onReceive(locationManager.$location) { location in
                guard let loc = location else { return }
                viewModel.findUserRealPosition(loc: loc.coordinate, offset: markerOffset)
            }
        }
    }
    
    private func createAlert(alertItem: AlertItem) -> Alert {
        Alert(title: alertItem.title,
              message: alertItem.message,
              dismissButton: alertItem.dismissButton)
    }

    private func cancelOrderAlert() -> Alert {
        Alert(
            title: Text("cancel_order"),
            message: Text("cancel_order_question"),
            primaryButton: .destructive(Text("cancel_order")) {
                viewModel.cancelMyOrder()
            },
            secondaryButton: .cancel(Text("continue")) {
                viewModel.showCancelOrderAlert.toggle()
            }
        )
    }
    
    
    private var mapLayer: some View {
        let uri = StyleURI(rawValue: "mapbox://styles/uzdriver/cl0j7klhe001415o8wpkop805")!
        let cameraOptions = CameraOptions(center: viewModel.location, zoom: 12)
        
        return CustomMapView(markerOffset: $markerOffset,
                             currentCenterCoordinate: $viewModel.selectedLocation,
                             viewModel: viewModel,
                             vp: cameraOptions,
                             mapStyle: uri)
        .ignoresSafeArea()
        .onChange(of: markerOffset) {
            viewModel.reverseGeocodeIfNeeded(offset: markerOffset)
        }
    }
    
    
    private func drawerAndBonusButton() -> some View {
        HStack{
            Button(action: {
                withAnimation {
                    isDrawerOpen.toggle()
                }
            }) {
                DrawerBtn(name: "menu_navigation", fromAssets: true)
            }
            Spacer()
            Button(action: {
                viewModel.serviceTariffRequest()
                viewModel.showBonusDialog.toggle()
            }, label: {
                BonusHomeItem(viewModel: viewModel)
            })
        }
        .padding(.top, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

 
    private var contentViews: some View {
        StatusDependentView(markerOffset: $markerOffset, viewModel: viewModel)
    }

    
    private var drawerLayer: some View {
        ZStack {
            if isDrawerOpen {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isDrawerOpen.toggle()
                        }
                    }
            }
            
            HomeScreenDrawer(isOpen: $isDrawerOpen, selectedScreen: $selectedScreen,
                             viewModel: viewModel)
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
                getDestinationView(for: selectedScreen ?? .myTrips)
            }
        }
    }

    
    
    private func getDestinationView(for destination: DestinationScreen) -> some View {
        @State var paymentMethod: String = getPaymentMethod()

        switch destination {
            case .myTrips:
                if viewModel.addressHistoryResponse != nil {
                    return AnyView(MyTripsScreen())
                }else {
                    return AnyView(PaymentScreen(paymentMethod: $paymentMethod))
                }
                
            case .paymentMethod:
                return AnyView(PaymentScreen(paymentMethod: $paymentMethod))
            case .favouriteAddresses:
                return AnyView(FavScreen())
            case .discount:
                return AnyView(DiscountScreen())
            case .profile:
                return AnyView(ProfileScreen())
            case .news:
                return AnyView(NewsScreen())
            case .aboutApp:
                return AnyView(AboutAppScreen())
        }
    }

}
