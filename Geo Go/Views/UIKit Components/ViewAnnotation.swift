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
    
    init(text: String, maxCharacters: Int = 30) {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
