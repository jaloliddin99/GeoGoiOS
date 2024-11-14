//
//  ViewAnnotation.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 16/07/24.
//

import Foundation

import UIKit

class AnnotationView: UIView {
    private let label: UILabel
    
    init(text: String, maxCharacters: Int = 37) {
        self.label = UILabel()
        super.init(frame: .zero)
        let truncatedText = text.count > maxCharacters ? String(text.prefix(maxCharacters)) : text
        setupView(text: truncatedText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(text: String) {
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.9
//        

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 12

        
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
