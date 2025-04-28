//
//  ActivityManager.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 25/04/25.
//


import Foundation
import ActivityKit
import RideTrackingShared

@available(iOS 16.1, *)
final class ActivityManager {
    static let shared = ActivityManager()
    private init() {}
    
    private var currentActivity: Activity<DriverActivityAttributes>?
    private var currentFinishOrderActivity: Activity<FinishOrderAttributes>?
    
    func startActivity(
        initialLat: Double, initialLon: Double,
        clientLat: Double, clientLon: Double,
        regNum: String, brand: String, model: String, color: String,
        speed: Double
    ) async {
        let attributes = DriverActivityAttributes(
            initialLat: initialLat, initialLon: initialLon,
            clientLat: clientLat, clientLon: clientLon,
            regNum: regNum, brand: brand, model: model, color: color
        )
        
        let contentState = DriverActivityAttributes.ContentState(
            currentLat: initialLat,
            currentLon: initialLon,
            speed: speed
        )
        
        do {
            let activity = try Activity<DriverActivityAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil 
            )
            self.currentActivity = activity
            print("✅ Live Activity started")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    // Update driver's location
    func updateDriverLocation(to lat: Double, lon: Double, speed: Double) async {
        let updatedState = DriverActivityAttributes.ContentState(
            currentLat: lat,
            currentLon: lon,
            speed: speed
        )
        
        guard let activity = currentActivity else {
            print("⚠️ No active Live Activity found")
            return
        }
        
        do {
            await activity.update(using: updatedState)
            print("🔄 Live Activity updated: \(lat), \(lon)")
        } catch {
            print("❌ Failed to update Live Activity: \(error)")
        }
    }
    
    // End the activity (e.g. trip completed)
    func endActivity() async {
        do {
            try await currentActivity?.end(
                using: DriverActivityAttributes.ContentState(currentLat: 0, currentLon: 0, speed: 0),
                dismissalPolicy: .immediate
            )
            print("🛑 Live Activity ended")
            currentActivity = nil
        } catch {
            print("❌ Failed to end Live Activity: \(error)")
        }
    }
    
    
    
    func startFinishOrderActivity(
     orderAmount: String,
     bonusAmount: String?,
     regNum: String
    ) async {
        let attributes = FinishOrderAttributes( orderAmount: orderAmount,
                                                bonusAmount: bonusAmount,
                                                regNum: regNum)
        
        
        let contentState = FinishOrderAttributes.ContentState(
            orderAmount: orderAmount,
            bonusAmount: bonusAmount,
            regNum: regNum
        )
        
        do {
            let activity = try Activity<FinishOrderAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            self.currentFinishOrderActivity = activity
            print("✅ Live Activity started ------ ")
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
        }
    }
    
    func updateOrderEndActivity(
        orderAmount: String,
        bonusAmount: String?,
        regNum: String
    ) async {
        let contentState = FinishOrderAttributes.ContentState(
            orderAmount: orderAmount,
            bonusAmount: bonusAmount,
            regNum: regNum
        )
        
        guard let activity = currentFinishOrderActivity else {
            print("⚠️ No active Live Activity found")
            return
        }
        
        do {
            await activity.update(using: contentState)
            print("🔄 Live Activity updated ------: \(orderAmount), \(bonusAmount)")
        } catch {
            print("❌ Failed to update Live Activity: \(error)")
        }
    }
    
    
    func endFinishOrderActivity() async {
        do {
            try await currentFinishOrderActivity?.end(
                using: FinishOrderAttributes.ContentState(
                     orderAmount: "",
                     bonusAmount: "",
                     regNum: ""),
                dismissalPolicy: .immediate
            )
            print("🛑 Live Activity ended")
            currentFinishOrderActivity = nil
        } catch {
            print("❌ Failed to end Live Activity: \(error)")
        }
    }
    
    
    
    
    
}
