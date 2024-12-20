//
//  ChatView.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 18/12/24.
//

import Foundation
import SwiftUI


struct ChatView: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject private var chatViewModel = ChatViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationHeaderView(presentationMode: presentationMode)
                ChatMessagesView(messages: chatViewModel.messageObserver, viewModel: viewModel)
                ChatInputView(chatViewModel: chatViewModel, viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            
        }
    }
}

// MARK: - Subviews

/// Chat Messages Section
struct ChatMessagesView: View {
    let messages: [MessageObject]
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages,  id: \.messageId) { message in
                        ChatBubbleView(message: message)
                    }
                }
                .padding(.horizontal)
            }
            
            VStack {
                Spacer()
                CallButton(viewModel: viewModel)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.main.opacity(0.1))
        .onAppear {
            DataHolder.inHome = false
        }
    }
}

/// Individual Chat Bubble
struct ChatBubbleView: View {
    let message: MessageObject
    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(message.message)
                        .padding(12)
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(ChatBubbleShape(isSentByMe: true))
                        .frame(maxWidth: 250, alignment: .trailing)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 12, height: 8)
                            .foregroundColor(message.isRead ? .blue : .gray)
                            .offset(x: 2)
                        
                        if message.isRead {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width: 12, height: 8)
                                .foregroundColor(.blue)
                                .offset(x: -2)
                        }
                    }
                    .padding(.trailing, 8)
                }
            } else {
                VStack(alignment: .leading) {
                    Text(message.message)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(ChatBubbleShape(isSentByMe: false))
                        .frame(maxWidth: 250, alignment: .leading)
                }
                Spacer()
            }
        }
    }
}



struct CallButton: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        Button(action: {
            guard let phone = viewModel.getOrderDetail else { return }
            makePhoneCall(phone)
        }) {
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.white)
                Text("Call")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.main)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white, lineWidth: 3)
            )
            .shadow(color: .black.opacity(0.2), radius: 10)
        }
        .padding(.bottom, 12)
    }
}

/// Chat Input Section
struct ChatInputView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @ObservedObject var viewModel: MainViewModel
    @State private var msg: String = ""
    
    var body: some View {
        HStack {
            TextField("Type a message..", text: $msg)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 56)
                .background(Color.appGray)
                .cornerRadius(10)
                .padding(.horizontal, 12)
            
            Button(action: {
                print("hello")
                guard let order = viewModel.getOrderDetail else { return }
                print("hello1 ")

                guard let carNum = order.assignee?.car.regNum else { return }
                print("hello2 ")

                guard let number = UserDefaults.standard.string(forKey: Constants.USER_PHONE) else {return}
                print("hello3 ")

                chatViewModel.sendMessage(DataHolder.orderId, DataHolder.chatId, carNum, msg, number)
                msg = ""
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .padding(.horizontal)
            }
        }
        .padding(12)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

/// Navigation Header Section
struct NavigationHeaderView: View {
    let presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
            Image("profile-image")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text("Sadulla aka")
                    .font(.headline)
                Text("+998 90 966 42 00")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                print("Menu button tapped")
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: 90))
            }
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: 56)
        
    }
}

// MARK: - Helper Models and Extensions


/// Chat Bubble Shape
struct ChatBubbleShape: Shape {
    var isSentByMe: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if isSentByMe {
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: 15, height: 15), style: .continuous)
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.maxY))
        } else {
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: 15, height: 15), style: .continuous)
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - 10))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 10, y: rect.maxY))
        }
        
        return path
    }
}

