//
//  OrderRoute.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 26/03/25.
//

import SwiftUI

struct OrderRoute: View {
    var routeItems: [RouteItem]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(routeItems.indices, id: \.self) { index in
                let routeItem = routeItems[index]
                let isFirst = index == 0
                let isLast = index == routeItems.count - 1
                let isIntermediate = index > 2 && !isFirst && !isLast
                
                if isFirst {
                    RouteRowView(
                        iconName: "people_rise_hand",
                        title: String(format: NSLocalizedString("arrival_time".localize(), comment: ""), "10:32"),
                        subtitle: routeItem.point.info.alias ?? "Unknown Address"
                    )
                    Divider().padding(.horizontal, 56)
                }
                
                if isIntermediate {
                    RouteRowView(
                        iconName: "pin.fill",
                        title: "arrival".localize(),
                        subtitle: routeItem.point.info.alias ?? "Unknown address"
                    )
                    Divider().padding(.horizontal, 56)
                }
                
                if isLast {
                    RouteRowView(
                        iconName: "plus",
                        title: nil,
                        subtitle: "add_stops".localize(),
                        showChevron: true
                    )
                    
                    if routeItems.count > 1 {
                        Divider().padding(.horizontal, 56)
                        RouteRowView(
                            iconName: "flag.2.crossed",
                            title: "arrival".localize(),
                            subtitle: routeItem.point.info.alias ?? "Unknown address"
                        )
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
}


struct RouteRowView: View {
    var iconName: String
    var title: String?
    var subtitle: String?
    var showChevron: Bool = true
    
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                if let title = title {
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .lineLimit(1)
                        .font(.body)
                }
            }
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.txt)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
}

