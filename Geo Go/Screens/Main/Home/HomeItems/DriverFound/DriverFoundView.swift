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
    
    func OrderStatusView() -> some View{
        let status = viewModel.status
        var text: String = ""
        switch status {
            case 3:
                text = "Driver is coming to you! "
            case 4:
                text = "Driver arrived and  waiting for you! "
            case 5:
                text = "Travel Started! "
            default:
                text = "Driver is coming to you! "

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
        let orderInfo = viewModel.getOrderDetail!
        let car: Car = orderInfo.assignee!.car
        let num = car.regNum
        let color = car.color
        let carName = "\(color) \(car.brand) \(car.model)"
        HStack {
            
            if viewModel.status == 5 {
                RemoteImage(image: viewModel.image, radius: 24, imageName: "profile-image")
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
            let tariff = DataHolder.selectedTariff!
            Image(imageNameForType(tariff.icon))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 32)
            
            VStack(alignment: .leading) {
                Text("Tariff")
                    .font(.system(size: 12))
                
                let tariff =  convertTariff(lang: "en", data: tariff)
                Text(tariff)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            let cost: Double = orderInfo.cost.fixed ?? orderInfo.cost.amount
            Text(formatNumberWithSpaces(cost))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .padding(.trailing, 16)
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

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "dollarsign")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                }
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground).opacity(0.7))
                )
                
                HStack {
                    Image(systemName: "plus")
                        .padding(8)
                        .foregroundColor(.main)
                        .frame(maxWidth: 32, maxHeight: 32)
                        .background(.white)
                        .cornerRadius(20)
                    
                    Text("Add Second Place")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground).opacity(0.7))
                )
            }
            
            Button(action: {
                viewModel.showCancelOrderAlert.toggle()
            }, label: {
                Text("Cancel Order")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.red)
            })
            .foregroundColor(.red)
            .background(.white)
            .cornerRadius(10)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 1)
            )
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .padding(.bottom, 16)
        .background(.white)
    }
}


struct DriverFoundView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            BottomSheetView(isOpen: $viewModel.bottomSheetShown,
                            minHeight: 294,
                            maxHeight: 700) {
                DriverFoundViewUpperView(viewModel: viewModel)
            }
            
            VStack(spacing: 0){
                Spacer()
                DriverFoundViewBottomViewt(viewModel: viewModel)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
//struct DriverFoundView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleOrderInfo = OrderInfo(
//            state: 1,
//            costFixAllowed: true,
//            route: [
//                ClientAddress(
//                    address: SearchedAddress(
//                        name: "Sample Address",
//                        components: nil,
//                        types: nil,
//                        position: SearchPosition(lat: 37.7749, lon: -122.4194)
//                    ),
//                    entrance: nil,
//                    flat: nil,
//                    comment: nil,
//                    pickupPointId: nil
//                )
//            ],
//            assignee:AsigneeBody(
//                car: Car(alias: "Sample Alias", brand: "Sample Brand", model: "Sample Model", color: "Sample Color", regNum: "XYZ123"),
//                location: SearchPosition(lat: 37.7749, lon: -122.4194),
//                call: AssigneeCall(allow: "Yes", numbers: ["123-456-7890"])
//            ),
//            options: [12121212],
//            time: "12:00 PM",
//            needsProlongation: false,
//            comment: "Sample Comment",
//            distance: 5.0,
//            cost: Cost(
//                type: "Base",
//                amount: 25000.0,
//                calculation: "Base Fare + Distance",
//                modifier: CostModifier(type: "Discount", value: 5.0),
//                fixed: 20000.0,
//                details: [CostItem(title: "Base Fare", cost: 10.0), CostItem(title: "Distance", cost: 15.0)]
//            ),
//            executionTime: "15 mins",
//            usedBonuses: 2.0,
//            paymentMethod: PaymentMethod(kind: "Cash", id: "123", name: "Cash Payment", enoughMoney: true),
//            costChangeAllowed: true,
//            costChangeStep: false,
//            isComing: true,
//            paidWaitingStartsAt: "12:15 PM"
//        )
//        
//        return DriverFoundView(orderInfo: sampleOrderInfo)
//    }
//}
//
