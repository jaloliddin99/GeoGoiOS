//
//  MyTripsScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct MyTripsScreen: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var selectedTab: TripTab = .completed
    
    var body: some View {
        VStack {
            HStack {
                ForEach(TripTab.allCases, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Text(tab.rawValue)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedTab == tab ? Color.blue : Color.clear)
                            .foregroundColor(selectedTab == tab ? .white : .black)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .padding()
            
            List {
                ForEach(mockTrips(for: selectedTab), id: \.id) { trip in
                    TripCardView(trip: trip)
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(.white)
        .navigationTitle("My Trips")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            let delayInterval = 0.3
            for (index, info) in viewModel.addressHistoryResponse!.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayInterval * Double(index)) {
                    viewModel.dateOrderHistory(id: info.id, location: DataHolder.location)
                }
            }
        })
    }
    
    func mockTrips(for tab: TripTab) -> [ShortOrderInfo] {

        let transformedList = viewModel.addressHistoryResponse!
        
        switch tab {
            case .completed:
                return transformedList.filter { history in
                    history.state == 5
                }
            case .cancelled:
                return transformedList.filter { history in
                    history.state == 6
                }
        }
    }
}

enum TripTab: String, CaseIterable {
    case completed = "Completed"
    case cancelled = "Cancelled"
}


struct TripCardView: View {
    var trip: ShortOrderInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ForEach(trip.route, id: \.name) { t in
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                    Text(t.name)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
            }
            
            let time = formatTime(time: trip.time ?? "")
            Text(time)
                .font(.footnote)
                .foregroundColor(.gray)
            
            HStack {
                Text("Order price")
                    .fontWeight(.medium)
                Spacer()
                Text(formatNumberWithSpaces(trip.total ?? 0.0))
                    .fontWeight(.bold)
            }
            Button(action: {
                
            }) {
                Text("View order")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.vertical, 5)
    }
}

//#Preview {
//    MyTripsScreen()
//}
