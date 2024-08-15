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
                ForEach(mockTrips(for: selectedTab)) { trip in
                    TripCardView(trip: trip)
                }
            }
            .listStyle(PlainListStyle())
        }
        .background(.white)
        .navigationTitle("My Trips")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func mockTrips(for tab: TripTab) -> [OrderHistory] {
        
        let transformedList = viewModel.addressHistoryResponse!.map { it in
            OrderHistory(id: it.id, state: it.state, route: it.route, assignee: it.assignee, time: it.time, needsProlongation: it.needsProlongation, total: 5000)
        }
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
    var trip: OrderHistory
    
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
           
            
            Text(trip.time ?? "12:32 AM")
                .font(.footnote)
                .foregroundColor(.gray)
            HStack {
                Text("Order price")
                    .fontWeight(.medium)
                Spacer()
                Text(formatNumberWithSpaces(Double(trip.total)))
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
