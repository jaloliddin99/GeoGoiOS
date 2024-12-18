//
//  ViewAnnotation.swift
//  Geo Go
//
//  Created by Jaloliddin Abdullaev on 16/07/24.
//

import Foundation
import UIKit

class AnnotationView: UIView {
    private let numberLabel: UILabel
    private let textLabel: UILabel
    private let stackView: UIStackView
    
    init(number: String, text: String, maxCharacters: Int = 37) {
        // Initialize the labels and stack view
        self.numberLabel = UILabel()
        self.textLabel = UILabel()
        self.stackView = UIStackView()
        super.init(frame: .zero)
        
        // Truncate the text if it exceeds maxCharacters
        let truncatedText = text.count > maxCharacters ? String(text.prefix(maxCharacters)) : text
        
        // Setup the view
        setupView(number: number, text: truncatedText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(number: String, text: String) {
        // Configure the number label
        numberLabel.text = number
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = .systemFont(ofSize: 15, weight: .bold)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the text label
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 13, weight: .medium)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the stack view
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(textLabel)
        
        // Configure the view
        backgroundColor = .main
        layer.cornerRadius = 12
        layer.masksToBounds = false
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 12
        
        // Add stroke (border)
        layer.borderWidth = 3.0 // Stroke width
        layer.borderColor = UIColor.white.cgColor // Stroke color (example: blue)

        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            widthAnchor.constraint(equalTo: heightAnchor),

        ])
        

    }
}
