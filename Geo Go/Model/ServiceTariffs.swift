//
//  ServiceTariffs.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 04/07/24.
//

import Foundation
import CoreLocation

struct ServiceResponse: Codable {
    var kind: String
    var serviceId: String
    var settings: ServiceSettings?
    var tariffs: [ServiceTariff]?
}

struct ServiceSettings: Codable {
    var cardPaymentAllowed: Bool
    var dispatcherCall: DispatcherCall
    var mainInterface: String
}


struct DispatcherCall: Codable {
    var allow: String
    var number: String?
}


struct ServiceTariff: Codable, Identifiable, Equatable {
    var id: Int64
    var name: String
    var icon: String
    var description: String?
    var options: [TariffOption]
    var minCost: Double
    var cost: Double?
    var costChangeAllowed: Bool
    var costChangeStep: Double?
    var costChangeStep2: Double?
    var hint: String?
    var showEstimation: Bool
    var `Type`: String?
}

struct TariffOption: Codable, Identifiable, Equatable {
    var id: Int64
    var name: String
    var value: Double
    var mandatory: Bool
}


struct PaymentMethod: Codable {
    var kind: String
    var id: String?
    var name: String?
    var enoughMoney: Bool?
}

struct PaymentMethodParent: Codable {
    var prevServiceId: String
    var paymentMethod: PaymentMethod
}


struct UserSelectedAddress: Identifiable{
    let id = UUID()
    var addressName: String
    var addressLocation: CLLocationCoordinate2D
}


struct TariffDetails: Codable, Identifiable{
    var id = UUID()
    var titleDetails: String
    var descriptionDetails: String
}


class ServiceTariffSample {
    
    static let sampleData = ServiceResponse(
        kind: "Basic",
        serviceId: "001",
        settings: ServiceSettings(
            cardPaymentAllowed: true,
            dispatcherCall: DispatcherCall(
                allow: "Yes",
                number: "123-456-7890"
            ),
            mainInterface: "iOS"
        ),
        tariffs: [
            ServiceTariff(
                id: 1001,
                name: "tariffNameUz:Ekonom@tariffNameRu:Эконом@tariffNameKr:Ekonom@tariffNameEn:Econom@tariffNameGr:ეკონომიკა@",
                icon: "car_econom",
                description: "TitleUz:Kunlik safarlar uchun qulay tarif@\nTitleRu:Удобный тариф для ежедневных поездок@\nTitleEn:Convenient fare for daily trips@\nTitleKr:Kúnlik saparlar ushın qolay tarif@\nTitleGr:მოსახერხებელი მგზავრობის ყოველდღიური ვიზიტებს@\nTariffInfoUz:Matiz, Spark, Nexia@\nTariffInfoRu:Matiz, Spark, Nexia@\nTariffInfoEn:Matiz, Spark, Nexia@\nTariffInfoKr:Matiz, Spark, Nexia@\nTariffInfoGr:Matiz, Spark, Nexia@\nGrowthUz:Buyurtma narxi yomon ob-havoda ko'tariladi. @\nGrowthRu:Цена заказа будет увеличиваться в плохую погоду. @\nGrowthEn:The price of the order will increase in bad weather.@\nGrowthKr:Buyırtpa bahası jaman hawa rayında kóteriledi.@\nGrowthGr:შეკვეთის ფასი ცუდ ამინდში გაიზრდება..@\nBonus_uz:Birinchi safar uchun 100 000 so'm cashback@\nBonus_ru:100 000 cум кэшбэк за первую поездку@\nBonus_en:Cashback 100 000 UZS for the first trip@\nBonus_kr:Birinshi sapar ushın 100 000 swm keshbek@\nBonus_gr:Cashback 100 000 UZS პირველი მოგზაურობა@\nBonusReturn_uz:Keyingi safarlar uchun 5% keshbek@\nBonusReturn_ru:5% кэшбэка на последующие поездки@\nBonusReturn_en:5% cashback for subsequent trips@\nBonusReturn_kr:Keyingi saparlar ushın 5% keshbek@\nBonusReturn_gr:5% cashback შემდგომი ვიზიტებისთვის@\nTariffTitleDetails_uz:1Shahar ichi@\nTariffTitleDetails_ru:1По городу@\nTariffTitleDetails_en:1By city@\nTariffTitleDetails_kr:1Qalada@\nTariffTitleDetails_gr:1ქალაქში@\nTariffDescriptionDetails_uz:1Boshlanishi — 5000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 300 so'm/min@\nTariffDescriptionDetails_ru:1Мин. цена — 5000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 300 сум/мин@\nTariffDescriptionDetails_en:1Minimum price-5000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:1Minimal baha — 5000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 300 swm/min@\nTariffDescriptionDetails_gr:1მინიმალური ფასი-5000 UZS.უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\nTariffTitleDetails_uz:2Shahar atrofi@\nTariffTitleDetails_ru:2За городом@\nTariffTitleDetails_en:2Suburb@\nTariffTitleDetails_kr:2Qala sırtı@\nTariffTitleDetails_gr:2გარეუბანი@\nTariffDescriptionDetails_uz:2Boshlanishi — 5000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 300 so'm/min@\nTariffDescriptionDetails_ru:2Мин. цена — 5000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 300 сум/мин@\nTariffDescriptionDetails_en:2Minimum price-5000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:2Minimal baha — 5000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 300 swm/min@\nTariffDescriptionDetails_gr:2მინიმალური ფასი-5000 UZS. უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-300 UZS/წთ@\n\nincreaseTitle_Uz:Taksiga talab yuqori bo'lganligi sababli @\nincreaseTitle_Ru:Из-за высокого спроса на такси  @\nincreaseTitle_En:Due to the high demand for taxis @\nincreaseTitle_Kr:Taksine talap joqarı bolǵanlıǵı sebepli @\nincreaseTitle_Gr:ტაქსებზე მაღალი მოთხოვნის გამო @\n\nincreaseDesc_Uz:Tarif vaqtincha oshirildi@\nincreaseDesc_Ru:Тариф временно увеличен @\nincreaseDesc_En:The tariff has been temporarily increased @\nincreaseDesc_Kr:Tarif waqtınsha asırıldı  @\nincreaseDesc_Gr:ტარიფი დროებით გაიზარდა@\n\n\n\nincreaseDialog_Uz:Taksilarga talab yuqori bo'lganligi sababli, sizning atrofingizda bo'sh avtomobil etishmayapti. Safar narxi vaqtincha oshdi-bu sizning hududingizga ko'proq haydovchilarni jalb qiladi. Ular etarli bo'lgandan so'ng, narx darhol odatiy holatga qaytadi.@\nincreaseDialog_Ru:Из-за высокого спроса на такси рядом с вами не хватает свободных машин. Стоимость поездок временно увеличилась - это позволит привлечь больше водителей в ваш район. Как только их будет достаточно, цена сразу же станет прежней.@\nincreaseDialog_En:Due to the high demand for taxis, there are not enough available cars near you. The cost of trips has temporarily increased - this will attract more drivers to your area. As soon as there are enough of them, the price will immediately become the same.@\nincreaseDialog_Gr:ტაქსებზე მაღალი მოთხოვნის გამო, თქვენთან ახლოს არ არის საკმარისი ხელმისაწვდომი მანქანები. მოგზაურობის ღირებულება დროებით გაიზარდა-ეს უფრო მეტ მძღოლს მოიზიდავს თქვენს მხარეში. როგორც კი საკმარისი იქნება, ფასი მაშინვე იგივე გახდება.@\nincreaseDialog_Kr:Taksilerge talap joqarı bolǵanlıǵı sebepli, sizdiń átirapıńızda bos avtomobil etiwmayapti. Sapar bahası waqtınsha asdı -bul sizdiń aymaǵıngizga kóbirek aydawshılardı tartadı. Olar etarli bolǵandan keyin, baha tezlik penen ádetiy jaǵdayǵa qaytadı.@\n\n\n\nBonusTitleUz:1Birinchi bosqichda safar yakunida sizga 5% miqdorda keshbek beriladi.@\nBonusTitleRu:1На первом этапе вы получите кэшбэк в размере 5% в конце поездки.@\nBonusTitleEn:1At the end of the trip in the first stage, you will be given a cashback of 5%.@\nBonusTitleKr:1Birinshi basqıshda sapar juwmaǵında sizge 5% muǵdarda keshbek beriledi.@\nBonusTitleGr:1მოგზაურობის დასასრულს პირველ ეტაპზე, თქვენ მოგეცემათ cashback of 5%.@\nBonusDescriptionUz:1Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin. Keyingi bosqichga o'tish uchun 20ta safarni amalga oshirish kerak.@\nBonusDescriptionRu:1Вы можете использовать эти средства вместо оплаты для проезда в такси. Чтобы перейти к следующему этапу, необходимо совершить 20 поездок.@\nBonusDescriptionEn:1You can use this funds in the place of the road entrance to the taxi. To proceed to the next stage, it is necessary to make 20 trips.@\nBonusDescriptionKr:1Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin. Keyingi basqıshqa ótiw ushın 20 dane sapardı ámelge asırıw kerek.@\nBonusDescriptionGr:1თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას. გაგრძელება მომდევნო ეტაპზე, აუცილებელია, რათა 20 ვიზიტებს.@\n\n\nBonusTitleUz:2Ikkinchi bosqichda safar yakunida sizga 7% miqdorda keshbek beriladi.@\nBonusTitleRu:2На втором этапе вы получите кэшбэк в размере 7% в конце поездки.@\nBonusTitleEn:2At the end of the trip in the second stage, you will be given a cashback in the amount of 7%.@\nBonusTitleKr:2Ekinshi basqıshda sapar juwmaǵında sizge 7% muǵdarda keshbek beriledi.@\nBonusTitleGr:2მოგზაურობის ბოლოს მეორე ეტაპზე, თქვენ მოგეცემათ cashback თანხის 7% @\nBonusDescriptionUz:2Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin. Keyingi bosqichga o'tish uchun 50ta safarni amalga oshirish kerak.@\nBonusDescriptionRu:2Вы можете использовать эти средства вместо оплаты для проезда в такси. Чтобы перейти к следующему шагу, необходимо совершить 50 поездок.@\nBonusDescriptionEn:2You can use this funds in the place of the road entrance to the taxi. To proceed to the next stage, it is necessary to make 50 trips.@\nBonusDescriptionKr:2Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin. Keyingi basqıshqa ótiw ushın 50 ta sapardı ámelge asırıw kerek.@\nBonusDescriptionGr:2თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას. გაგრძელება მომდევნო ეტაპზე, აუცილებელია, რათა 50 ვიზიტებს.@\n\nBonusTitleUz:3Uchinchi bosqichda safar yakunida sizga 10% miqdorda keshbek beriladi.@\nBonusTitleRu:3На третьем этапе вы получите кэшбэк в размере 10% в конце поездки.@\nBonusTitleEn:3At the end of the trip in the third stage, you will be given a cashback of 10%.@\nBonusTitleKr:3Úshinshi basqıshda sapar juwmaǵında sizge 10% muǵdarda keshbek beriledi.@\nBonusTitleGr:3დასასრულს მოგზაურობა მესამე ეტაპზე, თქვენ მოგეცემათ cashback of 10%.@\nBonusDescriptionUz:3Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin.@\nBonusDescriptionRu:3Вы можете использовать эти средства вместо оплаты для проезда в такси.@\nBonusDescriptionEn:3You can use this funds in the place of the road entrance to the taxi.@\nBonusDescriptionKr:3Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin.@\nBonusDescriptionGr:3თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას.@\n\nBonusLabelUz:Har bir safar uchun faqat 2000 so'm foydalanish mumkin@\nBonusLabelRu:За каждую поездку можно использовать только 2000 сум@\nBonusLabelEn:Only 2000 UZS can be used for each trip@\nBonusLabelKr:Hár bir sapar ushın tek 2000 swm paydalanıw múmkin@\nBonusLabelGr:მხოლოდ 2000 soums შეიძლება გამოყენებულ იქნას თითოეული მოგზაურობა@",
                options: [
                    TariffOption(
                        id: 201,
                        name: "Extra luggage",
                        value: 5.0,
                        mandatory: false
                    ),
                    TariffOption(
                        id: 202,
                        name: "Pet friendly",
                        value: 7.0,
                        mandatory: false
                    )
                ],
                minCost: 10.0,
                cost: 12.0,
                costChangeAllowed: true,
                costChangeStep: 1.0,
                costChangeStep2: 0.5,
                hint: "Ideal for short city trips.",
                showEstimation: true,
                Type: "Fixed"
            ),
            ServiceTariff(
                id: 1002,
                name: "tariffNameUz:Ekonom@tariffNameRu:Эконом@tariffNameKr:Ekonom@tariffNameEn:Econom@tariffNameGr:ეკონომიკა@",
                icon: "carType_4",
                description: "TitleUz:Kunlik safarlar uchun qulay tarif@\nTitleRu:Удобный тариф для ежедневных поездок@\nTitleEn:Convenient fare for daily trips@\nTitleKr:Kúnlik saparlar ushın qolay tarif@\nTitleGr:მოსახერხებელი მგზავრობის ყოველდღიური ვიზიტებს@\nTariffInfoUz:Matiz, Spark, Nexia@\nTariffInfoRu:Matiz, Spark, Nexia@\nTariffInfoEn:Matiz, Spark, Nexia@\nTariffInfoKr:Matiz, Spark, Nexia@\nTariffInfoGr:Matiz, Spark, Nexia@\nGrowthUz:Buyurtma narxi yomon ob-havoda ko'tariladi. @\nGrowthRu:Цена заказа будет увеличиваться в плохую погоду. @\nGrowthEn:The price of the order will increase in bad weather.@\nGrowthKr:Buyırtpa bahası jaman hawa rayında kóteriledi.@\nGrowthGr:შეკვეთის ფასი ცუდ ამინდში გაიზრდება..@\nBonus_uz:Birinchi safar uchun 100 000 so'm cashback@\nBonus_ru:100 000 cум кэшбэк за первую поездку@\nBonus_en:Cashback 100 000 UZS for the first trip@\nBonus_kr:Birinshi sapar ushın 100 000 swm keshbek@\nBonus_gr:Cashback 100 000 UZS პირველი მოგზაურობა@\nBonusReturn_uz:Keyingi safarlar uchun 5% keshbek@\nBonusReturn_ru:5% кэшбэка на последующие поездки@\nBonusReturn_en:5% cashback for subsequent trips@\nBonusReturn_kr:Keyingi saparlar ushın 5% keshbek@\nBonusReturn_gr:5% cashback შემდგომი ვიზიტებისთვის@\nTariffTitleDetails_uz:1Shahar ichi@\nTariffTitleDetails_ru:1По городу@\nTariffTitleDetails_en:1By city@\nTariffTitleDetails_kr:1Qalada@\nTariffTitleDetails_gr:1ქალაქში@\nTariffDescriptionDetails_uz:1Boshlanishi — 5000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 300 so'm/min@\nTariffDescriptionDetails_ru:1Мин. цена — 5000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 300 сум/мин@\nTariffDescriptionDetails_en:1Minimum price-5000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:1Minimal baha — 5000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 300 swm/min@\nTariffDescriptionDetails_gr:1მინიმალური ფასი-5000 UZS.უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\nTariffTitleDetails_uz:2Shahar atrofi@\nTariffTitleDetails_ru:2За городом@\nTariffTitleDetails_en:2Suburb@\nTariffTitleDetails_kr:2Qala sırtı@\nTariffTitleDetails_gr:2გარეუბანი@\nTariffDescriptionDetails_uz:2Boshlanishi — 5000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 300 so'm/min@\nTariffDescriptionDetails_ru:2Мин. цена — 5000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 300 сум/мин@\nTariffDescriptionDetails_en:2Minimum price-5000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:2Minimal baha — 5000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 300 swm/min@\nTariffDescriptionDetails_gr:2მინიმალური ფასი-5000 UZS. უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-300 UZS/წთ@\n\nincreaseTitle_Uz:Taksiga talab yuqori bo'lganligi sababli @\nincreaseTitle_Ru:Из-за высокого спроса на такси  @\nincreaseTitle_En:Due to the high demand for taxis @\nincreaseTitle_Kr:Taksine talap joqarı bolǵanlıǵı sebepli @\nincreaseTitle_Gr:ტაქსებზე მაღალი მოთხოვნის გამო @\n\nincreaseDesc_Uz:Tarif vaqtincha oshirildi@\nincreaseDesc_Ru:Тариф временно увеличен @\nincreaseDesc_En:The tariff has been temporarily increased @\nincreaseDesc_Kr:Tarif waqtınsha asırıldı  @\nincreaseDesc_Gr:ტარიფი დროებით გაიზარდა@\n\n\n\nincreaseDialog_Uz:Taksilarga talab yuqori bo'lganligi sababli, sizning atrofingizda bo'sh avtomobil etishmayapti. Safar narxi vaqtincha oshdi-bu sizning hududingizga ko'proq haydovchilarni jalb qiladi. Ular etarli bo'lgandan so'ng, narx darhol odatiy holatga qaytadi.@\nincreaseDialog_Ru:Из-за высокого спроса на такси рядом с вами не хватает свободных машин. Стоимость поездок временно увеличилась - это позволит привлечь больше водителей в ваш район. Как только их будет достаточно, цена сразу же станет прежней.@\nincreaseDialog_En:Due to the high demand for taxis, there are not enough available cars near you. The cost of trips has temporarily increased - this will attract more drivers to your area. As soon as there are enough of them, the price will immediately become the same.@\nincreaseDialog_Gr:ტაქსებზე მაღალი მოთხოვნის გამო, თქვენთან ახლოს არ არის საკმარისი ხელმისაწვდომი მანქანები. მოგზაურობის ღირებულება დროებით გაიზარდა-ეს უფრო მეტ მძღოლს მოიზიდავს თქვენს მხარეში. როგორც კი საკმარისი იქნება, ფასი მაშინვე იგივე გახდება.@\nincreaseDialog_Kr:Taksilerge talap joqarı bolǵanlıǵı sebepli, sizdiń átirapıńızda bos avtomobil etiwmayapti. Sapar bahası waqtınsha asdı -bul sizdiń aymaǵıngizga kóbirek aydawshılardı tartadı. Olar etarli bolǵandan keyin, baha tezlik penen ádetiy jaǵdayǵa qaytadı.@\n\n\n\nBonusTitleUz:1Birinchi bosqichda safar yakunida sizga 5% miqdorda keshbek beriladi.@\nBonusTitleRu:1На первом этапе вы получите кэшбэк в размере 5% в конце поездки.@\nBonusTitleEn:1At the end of the trip in the first stage, you will be given a cashback of 5%.@\nBonusTitleKr:1Birinshi basqıshda sapar juwmaǵında sizge 5% muǵdarda keshbek beriledi.@\nBonusTitleGr:1მოგზაურობის დასასრულს პირველ ეტაპზე, თქვენ მოგეცემათ cashback of 5%.@\nBonusDescriptionUz:1Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin. Keyingi bosqichga o'tish uchun 20ta safarni amalga oshirish kerak.@\nBonusDescriptionRu:1Вы можете использовать эти средства вместо оплаты для проезда в такси. Чтобы перейти к следующему этапу, необходимо совершить 20 поездок.@\nBonusDescriptionEn:1You can use this funds in the place of the road entrance to the taxi. To proceed to the next stage, it is necessary to make 20 trips.@\nBonusDescriptionKr:1Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin. Keyingi basqıshqa ótiw ushın 20 dane sapardı ámelge asırıw kerek.@\nBonusDescriptionGr:1თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას. გაგრძელება მომდევნო ეტაპზე, აუცილებელია, რათა 20 ვიზიტებს.@\n\n\nBonusTitleUz:2Ikkinchi bosqichda safar yakunida sizga 7% miqdorda keshbek beriladi.@\nBonusTitleRu:2На втором этапе вы получите кэшбэк в размере 7% в конце поездки.@\nBonusTitleEn:2At the end of the trip in the second stage, you will be given a cashback in the amount of 7%.@\nBonusTitleKr:2Ekinshi basqıshda sapar juwmaǵında sizge 7% muǵdarda keshbek beriledi.@\nBonusTitleGr:2მოგზაურობის ბოლოს მეორე ეტაპზე, თქვენ მოგეცემათ cashback თანხის 7% @\nBonusDescriptionUz:2Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin. Keyingi bosqichga o'tish uchun 50ta safarni amalga oshirish kerak.@\nBonusDescriptionRu:2Вы можете использовать эти средства вместо оплаты для проезда в такси. Чтобы перейти к следующему шагу, необходимо совершить 50 поездок.@\nBonusDescriptionEn:2You can use this funds in the place of the road entrance to the taxi. To proceed to the next stage, it is necessary to make 50 trips.@\nBonusDescriptionKr:2Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin. Keyingi basqıshqa ótiw ushın 50 ta sapardı ámelge asırıw kerek.@\nBonusDescriptionGr:2თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას. გაგრძელება მომდევნო ეტაპზე, აუცილებელია, რათა 50 ვიზიტებს.@\n\nBonusTitleUz:3Uchinchi bosqichda safar yakunida sizga 10% miqdorda keshbek beriladi.@\nBonusTitleRu:3На третьем этапе вы получите кэшбэк в размере 10% в конце поездки.@\nBonusTitleEn:3At the end of the trip in the third stage, you will be given a cashback of 10%.@\nBonusTitleKr:3Úshinshi basqıshda sapar juwmaǵında sizge 10% muǵdarda keshbek beriledi.@\nBonusTitleGr:3დასასრულს მოგზაურობა მესამე ეტაპზე, თქვენ მოგეცემათ cashback of 10%.@\nBonusDescriptionUz:3Siz ushbu mablag'ni taksiga yo'l kira o'rnida foydalanishingiz mumkin.@\nBonusDescriptionRu:3Вы можете использовать эти средства вместо оплаты для проезда в такси.@\nBonusDescriptionEn:3You can use this funds in the place of the road entrance to the taxi.@\nBonusDescriptionKr:3Siz bul aqshanı taksine jol kirey ornında paydalanıwıńız múmkin.@\nBonusDescriptionGr:3თქვენ შეგიძლიათ გამოიყენოთ ეს თანხები ტაქსის გზის შესასვლელის ადგილას.@\n\nBonusLabelUz:Har bir safar uchun faqat 2000 so'm foydalanish mumkin@\nBonusLabelRu:За каждую поездку можно использовать только 2000 сум@\nBonusLabelEn:Only 2000 UZS can be used for each trip@\nBonusLabelKr:Hár bir sapar ushın tek 2000 swm paydalanıw múmkin@\nBonusLabelGr:მხოლოდ 2000 soums შეიძლება გამოყენებულ იქნას თითოეული მოგზაურობა@",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 200000.0,
                costChangeStep2: 100000.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            ),
            ServiceTariff(
                id: 1003,
                name: "tariffNameUz:Ekonom@tariffNameRu:Эконом@tariffNameKr:Ekonom@tariffNameEn:Econom@tariffNameGr:ეკონომიკა@",
                icon: "car_delivery", // Replace with actual asset name if needed
                description: "TitleUz:Yetkazish uchun qulay tarif@\nTitleRu:Удобный тариф для доставки@\nTitleEn:Convenient fare for delivery@\nTitleKr:Jetkiziw ushın qolay tarif@\nTitleGr:ხელმისაწვდომი გადაზიდვის ტარიფები@\nTariffInfoUz:Matiz, Spark, Nexia@\nTariffInfoRu:Matiz, Spark, Nexia@\nTariffInfoEn:Matiz, Spark, Nexia@\nTariffInfoKr:Matiz, Spark, Nexia@\nTariffInfoGr:Matiz, Spark, Nexia@\nGrowthUz:Tarif vaqtincha oshirildi @\nGrowthRu:Тариф временно увеличен @\nGrowthEn:Tariff temporarily increased@\nGrowthKr:Tarif waqtınsha asırıldı @\nGrowthGr:ტარიფი დროებით გაიზარდა@\nBonus_uz:Birinchi safar uchun 100 000 so'm cashback@\nBonus_ru:100 000 сум кэшбэк за первую поездку@\nBonus_en:Cashback 100 000 UZS for the first trip@\nBonus_kr:Birinshi sapar ushın 100 000 swm cashback@\nBonus_gr:Cashback 100 000 UZS პირველი მოგზაურობა@\nBonusReturn_uz:Keyingi safarlar uchun 5% cashback@\nBonusReturn_ru:5% кэшбэка на последующие поездки@\nBonusReturn_en:5% cashback for subsequent trips@\nBonusReturn_kr:Keyingi saparlar ushın 5% cashback@\nBonusReturn_gr:5% cashback შემდგომი ვიზიტებისთვის@\nTariffTitleDetails_uz:1Shahar ichi@\nTariffTitleDetails_ru:1По городу@\nTariffTitleDetails_en:1By city@\nTariffTitleDetails_kr:1Qalada@\nTariffTitleDetails_gr:1ქალაქში@\nTariffDescriptionDetails_uz:1Boshlanishi — 10000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 500 so'm/min@\nTariffDescriptionDetails_ru:1Мин. цена — 10000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 500 сум/мин@\nTariffDescriptionDetails_en:1Minimum price-10000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:1Minimal baha — 10000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 500 swm/min@\nTariffDescriptionDetails_gr:1მინიმალური ფასი-10000 UZS.უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\nTariffTitleDetails_uz:2Shahar atrofi@\nTariffTitleDetails_ru:2За городом@\nTariffTitleDetails_en:2Suburb@\nTariffTitleDetails_kr:2Qala sırtı@\nTariffTitleDetails_gr:2გარეუბანი@\nTariffDescriptionDetails_uz:2Boshlanishi — 10000 so'm. Bepul kutish — 3 daq. Keyingi km — 2000 so'm/km. Kutish — 500 so'm/min@\nTariffDescriptionDetails_ru:2Мин. цена — 10000 сум. Бесп. ожидание 3мин. Следующий км-2000 cум/км. Платное ожид.- 500 сум/мин@\nTariffDescriptionDetails_en:2Minimum price-10000 UZS. Free wait-3 min. Next km-2000 UZS. Paid wait-500 UZS/min@\nTariffDescriptionDetails_kr:2Minimal baha — 10000 swm.Biypul kútiw — 3 daq. Keyingi km — 2000 swm/km.Pulli kútiw — 500 swm/min@\nTariffDescriptionDetails_gr:2მინიმალური ფასი-10000 UZS. უფასო ლოდინი-3 წთ.შემდეგი კმ-2000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\n\nincreaseTitle_Uz:Taksiga talab yuqori bo'lganligi sababli @\nincreaseTitle_Ru:Из-за высокого спроса на такси  @\nincreaseTitle_En:Due to the high demand for taxis @\nincreaseTitle_Kr:Taksine talap joqarı bolǵanlıǵı sebepli @\nincreaseTitle_Gr:ტაქსებზე მაღალი მოთხოვნის გამო @\n\nincreaseDesc_Uz:Tarif vaqtincha oshirildi@\nincreaseDesc_Ru:Тариф временно увеличен @\nincreaseDesc_En:The tariff has been temporarily increased @\nincreaseDesc_Kr:Tarif waqtınsha asırıldı  @\nincreaseDesc_Gr:ტარიფი დროებით გაიზარდა@\n\n\n\nincreaseDialog_Uz:Taksilarga talab yuqori bo'lganligi sababli, sizning atrofingizda bo'sh avtomobil etishmayapti. Safar narxi vaqtincha oshdi-bu sizning hududingizga ko'proq haydovchilarni jalb qiladi. Ular etarli bo'lgandan so'ng, narx darhol odatiy holatga qaytadi.@\nincreaseDialog_Ru:Из-за высокого спроса на такси рядом с вами не хватает свободных машин. Стоимость поездок временно увеличилась - это позволит привлечь больше водителей в ваш район. Как только их будет достаточно, цена сразу же станет прежней.@\nincreaseDialog_En:Due to the high demand for taxis, there are not enough available cars near you. The cost of trips has temporarily increased - this will attract more drivers to your area. As soon as there are enough of them, the price will immediately become the same.@\nincreaseDialog_Gr:ტაქსებზე მაღალი მოთხოვნის გამო, თქვენთან ახლოს არ არის საკმარისი ხელმისაწვდომი მანქანები. მოგზაურობის ღირებულება დროებით გაიზარდა-ეს უფრო მეტ მძღოლს მოიზიდავს თქვენს მხარეში. როგორც კი საკმარისი იქნება, ფასი მაშინვე იგივე გახდება.@\nincreaseDialog_Kr:Taksilerge talap joqarı bolǵanlıǵı sebepli, sizdiń átirapıńızda bos avtomobil etiwmayapti. Sapar bahası waqtınsha asdı -bul sizdiń aymaǵıngizga kóbirek aydawshılardı tartadı. Olar etarli bolǵandan keyin, baha tezlik penen ádetiy jaǵdayǵa qaytadı.@",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 2.0,
                costChangeStep2: 1.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            ),
            ServiceTariff(
                id: 1004,
                name: "tariffNameUz:Ekonom@tariffNameRu:Эконом@tariffNameKr:Ekonom@tariffNameEn:Econom@tariffNameGr:ეკონომიკა@",
                icon: "car_peregon",
                description: "TitleUz:Yetkazish uchun qulay tarif@\nTitleRu:Удобный тариф для доставки@\nTitleEn:Convenient fare for delivery@\nTitleKr:Jetkiziw ushın qolay tarif@\nTitleGr:ხელმისაწვდომი გადაზიდვის ტარიფები@\nTariffInfoUz:Matiz, Spark, Nexia@\nTariffInfoRu:Matiz, Spark, Nexia@\nTariffInfoEn:Matiz, Spark, Nexia@\nTariffInfoKr:Matiz, Spark, Nexia@\nTariffInfoGr:Matiz, Spark, Nexia@\nGrowthUz:Tarif vaqtincha oshirildi @\nGrowthRu:Тариф временно увеличен @\nGrowthEn:Tariff temporarily increased@\nGrowthKr:Tarif waqtınsha asırıldı @\nGrowthGr:ტარიფი დროებით გაიზარდა@\nBonus_uz:Birinchi safar uchun 100 000 so'm cashback@\nBonus_ru:100 000 сум кэшбэк за первую поездку@\nBonus_en:Cashback 100 000 UZS for the first trip@\nBonus_kr:Birinshi sapar ushın 100 000 swm cashback@\nBonus_gr:Cashback 100 000 UZS პირველი მოგზაურობა@\nBonusReturn_uz:Keyingi safarlar uchun 5% cashback@\nBonusReturn_ru:5% кэшбэка на последующие поездки@\nBonusReturn_en:5% cashback for subsequent trips@\nBonusReturn_kr:Keyingi saparlar ushın 5% cashback@\nBonusReturn_gr:5% cashback შემდგომი ვიზიტებისთვის@\nTariffTitleDetails_uz:1Shahar ichi@\nTariffTitleDetails_ru:1По городу@\nTariffTitleDetails_en:1By city@\nTariffTitleDetails_kr:1Qalada@\nTariffTitleDetails_gr:1ქალაქში@\nTariffDescriptionDetails_uz:1Boshlanishi — 10000 so'm. Bepul kutish — 3 daq. Keyingi km — 1000 so'm/km. Kutish — 500 so'm/min@\nTariffDescriptionDetails_ru:1Мин. цена — 10000 сум. Бесп. ожидание 3мин. Следующий км-1000 cум/км. Платное ожид.- 500 сум/мин@\nTariffDescriptionDetails_en:1Minimum price-10000 UZS. Free wait-3 min. Next km-1000 UZS. Paid wait-300 UZS/min@\nTariffDescriptionDetails_kr:1Minimal baha — 10000 swm.Biypul kútiw — 3 daq. Keyingi km — 1000 swm/km.Pulli kútiw — 500 swm/min@\nTariffDescriptionDetails_gr:1მინიმალური ფასი-10000 UZS.უფასო ლოდინი-3 წთ.შემდეგი კმ-1000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\nTariffTitleDetails_uz:2Shahar atrofi@\nTariffTitleDetails_ru:2За городом@\nTariffTitleDetails_en:2Suburb@\nTariffTitleDetails_kr:2Qala sırtı@\nTariffTitleDetails_gr:2გარეუბანი@\nTariffDescriptionDetails_uz:2Boshlanishi — 10000 so'm. Bepul kutish — 3 daq. Keyingi km — 2000 so'm/km. Kutish — 500 so'm/min@\nTariffDescriptionDetails_ru:2Мин. цена — 10000 сум. Бесп. ожидание 3мин. Следующий км-2000 cум/км. Платное ожид.- 500 сум/мин@\nTariffDescriptionDetails_en:2Minimum price-10000 UZS. Free wait-3 min. Next km-2000 UZS. Paid wait-500 UZS/min@\nTariffDescriptionDetails_kr:2Minimal baha — 10000 swm.Biypul kútiw — 3 daq. Keyingi km — 2000 swm/km.Pulli kútiw — 500 swm/min@\nTariffDescriptionDetails_gr:2მინიმალური ფასი-10000 UZS. უფასო ლოდინი-3 წთ.შემდეგი კმ-2000 UZS. ფასიანი ლოდინი-500 UZS/წთ@\n\nincreaseTitle_Uz:Taksiga talab yuqori bo'lganligi sababli @\nincreaseTitle_Ru:Из-за высокого спроса на такси  @\nincreaseTitle_En:Due to the high demand for taxis @\nincreaseTitle_Kr:Taksine talap joqarı bolǵanlıǵı sebepli @\nincreaseTitle_Gr:ტაქსებზე მაღალი მოთხოვნის გამო @\n\nincreaseDesc_Uz:Tarif vaqtincha oshirildi@\nincreaseDesc_Ru:Тариф временно увеличен @\nincreaseDesc_En:The tariff has been temporarily increased @\nincreaseDesc_Kr:Tarif waqtınsha asırıldı  @\nincreaseDesc_Gr:ტარიფი დროებით გაიზარდა@\n\n\n\nincreaseDialog_Uz:Taksilarga talab yuqori bo'lganligi sababli, sizning atrofingizda bo'sh avtomobil etishmayapti. Safar narxi vaqtincha oshdi-bu sizning hududingizga ko'proq haydovchilarni jalb qiladi. Ular etarli bo'lgandan so'ng, narx darhol odatiy holatga qaytadi.@\nincreaseDialog_Ru:Из-за высокого спроса на такси рядом с вами не хватает свободных машин. Стоимость поездок временно увеличилась - это позволит привлечь больше водителей в ваш район. Как только их будет достаточно, цена сразу же станет прежней.@\nincreaseDialog_En:Due to the high demand for taxis, there are not enough available cars near you. The cost of trips has temporarily increased - this will attract more drivers to your area. As soon as there are enough of them, the price will immediately become the same.@\nincreaseDialog_Gr:ტაქსებზე მაღალი მოთხოვნის გამო, თქვენთან ახლოს არ არის საკმარისი ხელმისაწვდომი მანქანები. მოგზაურობის ღირებულება დროებით გაიზარდა-ეს უფრო მეტ მძღოლს მოიზიდავს თქვენს მხარეში. როგორც კი საკმარისი იქნება, ფასი მაშინვე იგივე გახდება.@\nincreaseDialog_Kr:Taksilerge talap joqarı bolǵanlıǵı sebepli, sizdiń átirapıńızda bos avtomobil etiwmayapti. Sapar bahası waqtınsha asdı -bul sizdiń aymaǵıngizga kóbirek aydawshılardı tartadı. Olar etarli bolǵandan keyin, baha tezlik penen ádetiy jaǵdayǵa qaytadı.@",
                options: [
                    TariffOption(
                        id: 203,
                        name: "Priority boarding",
                        value: 15.0,
                        mandatory: true
                    ),
                    TariffOption(
                        id: 204,
                        name: "Complimentary refreshments",
                        value: 20.0,
                        mandatory: true
                    )
                ],
                minCost: 20.0,
                cost: 25.0,
                costChangeAllowed: true,
                costChangeStep: 2.0,
                costChangeStep2: 1.0,
                hint: "Best choice for business and pleasure.",
                showEstimation: false,
                Type: "Flexible"
            )
        ]
    )

}
