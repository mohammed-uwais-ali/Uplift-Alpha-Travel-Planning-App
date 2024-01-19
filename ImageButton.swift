//
//  ImageButton.swift
//  MapDemo
//
//  Created by Sam Pan on 11/13/23.
//  Copyright © 2023 Todd Sproull. All rights reserved.
//

import UIKit

class ImageButton: UIButton {

    private let buttonImage = UIImageView()
    private let buttonLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(buttonImage)
            
        // Set up additional text label
        buttonLabel.textAlignment = .center
        buttonLabel.font = UIFont.systemFont(ofSize: 18)
        buttonLabel.textColor = UIColor.gray
        addSubview(buttonLabel)
            
        // Set up constraints
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            buttonImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            buttonLabel.topAnchor.constraint(equalTo: buttonImage.bottomAnchor, constant: 0),
            buttonLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
//        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
//    @objc private func buttonTapped() {
//            print("Button tapped")
//        }

    func setMainImage(_ image: UIImage) {
        buttonImage.image = image
    }
    
    func setAdditionalText(_ text: String) {
        buttonLabel.text = text
    }
}
