//
//  PaymentScreen.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 14/08/24.
//

import SwiftUI

struct PaymentScreen: View {
    
    @Binding var paymentMethod: String
    @StateObject var viewModel = ViewModelAddCard()
    
    
    let gradients = [
        LinearGradient(colors: [Color.blue, Color.green], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.orange, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color.green, Color.cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
    ]
    
    @State private var isCashSelected: Bool = getPaymentMethod() == "cash"

    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Choose your default payment method")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.txt)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)
                
                paymentMethodSelection
                Divider()
                addCardLink
                
                if let cardList = viewModel.getAllCardResponse, !cardList.isEmpty {
                    cardListView(cards: cardList)
                } else {
                    emptyStateView
                }
                
                Spacer()
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Payment Method")
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getAllCardsRequest()
        }
        .onReceive(viewModel.$getAllCardResponse) { result in
            updatePaymentMethod(with: result)
        }
    }
    
    private var paymentMethodSelection: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Cash")
                .foregroundColor(.txt)
            Spacer()
            RadioButton(isSelected: isCashSelected)
        }
        .frame(height: 50)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isCashSelected {
                handleCashSelection()
            }
        }
    }
    
    private var addCardLink: some View {
        NavigationLink(destination: AddCardScreen()) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                Text("Add card")
                    .font(.custom("Roboto-Regular", size: 18))
                    .foregroundColor(Color.txt)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
        }
    }
    
    private func cardListView(cards: [CardData]) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                Spacer().frame(maxHeight: 16)
                ForEach(cards.indices, id: \.self) { index in
                    CardViewItem(card: cards[index], backgroundGradient: gradients[index % gradients.count], viewModel: viewModel)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            LottieEmptyStateView(fileName: "empty_list")
                .frame(width: 120, height: 120, alignment: .center)
                .padding()
            Text("No cards found")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 20)
    }
    
    private func handleCashSelection() {
        if let cardList = viewModel.getAllCardResponse, !cardList.isEmpty {
            if let cardId = getMainCardId(cards: cardList) {
                viewModel.setAsMainRequest(cardId: cardId)
            }
        }
    }
    
    private func updatePaymentMethod(with cardList: [CardData]?) {
        if let cardList = cardList, !cardList.isEmpty {
            isCashSelected = !hasMainCard(cards: cardList)
            setPaymentMethod(method: isCashSelected ? Constants.PAYMENT_TYPE_CASH :
                                Constants.PAYMENT_TYPE_CARD)
        } else {
            isCashSelected = true
            setPaymentMethod(method: Constants.PAYMENT_TYPE_CASH)
        }
        Constants.paymentMethod = PaymentMethod(
            kind: getPaymentMethod(), 
            id: "191000000026125",
            name: "Beznal",
            enoughMoney: true
        )
        paymentMethod = getPaymentMethod()
        
    }
}

func hasMainCard(cards: [CardData]) -> Bool {
    return cards.contains { $0.isMain }
}

func getMainCardId(cards: [CardData]) -> Int? {
    return cards.first(where: { $0.isMain })?.id
}



struct CardViewItem: View {
    let card: CardData
    let backgroundGradient: LinearGradient
    @ObservedObject var viewModel: ViewModelAddCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(card.cardName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                RadioButton(isSelected: card.isMain, color: .white)
                    .onTapGesture {
                        viewModel.setAsMainRequest(cardId: card.id)
                    }
            }
            
            Text(card.cardPan)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            Text("Expires: \(card.cardExpiry)")
                .font(.system(size: 14))
                .foregroundColor(.white)
            
        }
        .padding()
        .background(backgroundGradient) // Apply the gradient
        .cornerRadius(12)
    }
}
