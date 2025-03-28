//
//  NewsScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct NewsScreen: View {

    @StateObject var viewModel = NewsViewModel()
    @ObservedObject var vm: MainViewModel
    var body: some View {
       
        NavigationStack{
            ZStack{
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 6) {
                            ForEach(viewModel.news ?? []) { news in
                                NewsItem(newsDate: news, viewModel: vm)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            
            
        }
        .alert(item: $viewModel.alertItem){ alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 16)
        .background(.white)
        .navigationTitle("drawer_item_news".localize())
        .navigationBarTitleDisplayMode(.inline)
    }
    
}


struct NewsItem: View {
    let newsDate: NewsData
    var isDiscount: Bool = false
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        VStack(alignment: .leading) {
            
            let url = "https://feed.geogo.io/\(newsDate.image!)"
            RemoteImage(image: viewModel.image,width: .infinity, height: 180, imageName: "profile-image")
                .background(Color.gray.opacity(0.5))
                .cornerRadius(8)
                .clipped()
                .onAppear { viewModel.loadImage(fromURLString: url) }

            
            Text(newsDate.title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.txt)
                .lineLimit(2)
                .frame(alignment: .leading)
            
            
            if let description = newsDate.description {
                Text(description)
                    .font(.system(size: 14))
                    .frame(alignment: .leading)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray)
                
                
                if isDiscount {
                    if let date = newsDate.createdAt {
                        Text(convertISOToCustomFormat(isoDate: date))
                            .font(.system(size: 12))
                    }
                }else{
                    if let date = newsDate.date {
                        Text(formatDate(from: date))
                            .font(.system(size: 12))
                    }
                }
               
                
            }
            .padding(6)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(32)
            
            Text("txt_more".localize())
                .font(.system(size: 14))
                .foregroundColor(Color.blue)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.top, 8)
    }
}


