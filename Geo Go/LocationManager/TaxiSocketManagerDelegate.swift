//
//  TaxiSocketManagerDelegate.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 19/04/25.
//

protocol TaxiSocketManagerDelegate: AnyObject {
    func didReceiveOrderInfo(_ orderInfo: SOrderInfo)
    func didReceiveDriverLocation(_ rtd: SDriverRealTimeData)
    
}
