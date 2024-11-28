//
//  DriverFoundView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 03/08/24.
//

import SwiftUI

struct DriverFoundViewUpperView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            OrderStatusView()
            DriverDetailsView(viewModel: viewModel)
            TariffView(viewModel: viewModel)
            CellView()
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    func OrderStatusView() -> some View {
        let status = viewModel.status
        var text: String = ""
        let minutes: Int = Int((viewModel.getOrderDetail?.distance ?? 2.0) * 1000 / (12*60))
        switch status {
            case 3:
                if minutes == 1 {
                    text = String(format: NSLocalizedString("status_arrival_time", comment: ""), minutes)
                } else {
                    text = String(format: NSLocalizedString("status_arrival_time_plural", comment: ""), minutes)
                }
            case 4:
                text = NSLocalizedString("status_driver_waiting", comment: "")
            case 5:
                text = NSLocalizedString("status_travel_started", comment: "")
            default:
                text = NSLocalizedString("status_driver_coming", comment: "")
        }
        
        return Text(text)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.black)
            .padding(0)
    }

    
    
    
    func CellView() -> some View{
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(Array(viewModel.locationHolder.enumerated()), id: \.element.id) { index, location in
                    let disabled = index == 0
                    AddressListItem(title: location.addressName, image: "location_pin", disabled: disabled) {
                        
                    }
                }
            }
        }
    }
    

}



struct DriverDetailsView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        return HStack {
            let orderInfo = viewModel.getOrderDetail!
            if let car: Car = orderInfo.assignee?.car {
                let num = car.regNum
                let color = car.color
                let carName = "\(color) \(car.brand) \(car.model)"
                
                if viewModel.status == 5 {
                    RemoteRoundedImage(image: viewModel.image, radius: 24, imageName: "profile-image")
                        .onAppear { viewModel.loadImage(fromURLString: getImageUrl(orderDetails: viewModel.getOrderDetail!)) }
                }
                
                VStack(alignment: .leading) {
                    Text(carName)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black)
                    Text(num)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "phone")
                    .padding(8)
                    .foregroundColor(.white)
                    .frame(maxWidth: 40, maxHeight: 40)
                    .background(Color.main)
                    .cornerRadius(20)
                
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "ellipsis.message")
                        .padding(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: 40, maxHeight: 40)
                        .background(Color.main)
                        .cornerRadius(20)
                    
                    Text("0")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct TariffView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        let orderInfo = viewModel.getOrderDetail!
        HStack {
            let tariffName = UserDefaults.standard.string(forKey: Constants.TARIFF) ?? "Ekonom"
            let tariffIcon = UserDefaults.standard.string(forKey: Constants.TARIFF_ICON) ?? "Ekonom"
            Image(imageNameForType(tariffIcon))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 40)
            
            VStack(alignment: .leading) {
                Text("tariff")
                    .font(.system(size: 15, weight: .medium))
                
                Text(tariffName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            let cost: Double = orderInfo.cost.fixed ?? orderInfo.cost.amount
            Text(formatNumberWithSpaces(cost))
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.main)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground).opacity(0.7))
        )
    }
}


struct AddressListItem: View {
    let title: String
    let image: String
    let disabled: Bool

    var onEdit: () -> Void
    var body: some View {
        HStack {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color.green)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.white))
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.txt)
             .lineLimit(2)
             
            Spacer()
            
            Button(action: {
                onEdit()
            }, label: {
                EditBtn()
            })
            .disabled(disabled)
            
            
        }
    }
}

struct DriverFoundViewBottomViewt: View {
    @ObservedObject var viewModel: MainViewModel
    var paymentMethod: String = getPaymentMethod()

    var body: some View {
        VStack {
            
            HStack(spacing: 12) {
                HStack {
                    Image(paymentMethod == "cash" ? "cash" : "card")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground).opacity(0.7))
                )
                
                HStack {
                    Image(systemName: "plus")
                        .padding(10)
                        .foregroundColor(.main)
                        .frame(maxWidth: 32, maxHeight: 32)
                        .background(.white)
                        .cornerRadius(20)
                        .padding(.leading, 12)
                    
                    Text("add_second_space")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground).opacity(0.7))
                )
            }
            
            if viewModel.status != 5{
                Button(action: {
                    viewModel.showCancelOrderAlert.toggle()
                }, label: {
                    Text("cancel_order".localized.capitalizeFirstLetter())
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                })
                .foregroundColor(.red)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.red, lineWidth: 1)
                )
                .background(.white)
                .padding(.bottom, 16)

            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 24)
        .background(.white)
    }
}


struct DriverFoundView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var bottomSheetShown = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                BottomSheetViewCustom(
                    isOpen: self.$bottomSheetShown,
                    maxHeight: geometry.size.height * 0.6,
                    minHeight: 282,
                    content: {
                        DriverFoundViewUpperView(viewModel: viewModel)
                    }
                )
            }.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0){
                Spacer()
                DriverFoundViewBottomViewt(viewModel: viewModel)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
