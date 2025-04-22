//
//  CustomThumbSlider.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 22/04/25.
//


import SwiftUI
import UIKit

struct CustomThumbSlider: UIViewRepresentable {
    @Binding var value: Float
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.setThumbImage(UIImage(contentsOfFile: "car_from_above_2"), for: .normal)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = value
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomThumbSlider
        
        init(_ parent: CustomThumbSlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = sender.value
        }
    }
}
