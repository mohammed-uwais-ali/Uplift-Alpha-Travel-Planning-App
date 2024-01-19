//
//  StatisticalButton.swift
//  MapDemo
//
//  Created by Sam Pan on 11/10/23.
//  Copyright © 2023 Todd Sproull. All rights reserved.
//

import UIKit

class StatisticalButton: UIButton {
    private let percentage = UILabel()
    private let statisticType = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
            // Set up main text label
        percentage.textAlignment = .center
        percentage.font = UIFont.systemFont(ofSize: 25)
        percentage.accessibilityLabel = "This is the accessibility percentage for this category at this location."
        addSubview(percentage)
            
        // Set up additional text label
        statisticType.textAlignment = .center
        statisticType.font = UIFont.systemFont(ofSize: 18)
        statisticType.textColor = UIColor.gray
        statisticType.accessibilityLabel = "This is the accessibility category of the percentage score above."
        addSubview(statisticType)
            
        // Set up constraints
        percentage.translatesAutoresizingMaskIntoConstraints = false
        statisticType.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            percentage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            statisticType.topAnchor.constraint(equalTo: percentage.bottomAnchor, constant: 0),
            statisticType.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
            // Handle button tap
            print("Button tapped")
        }

    func setMainText(_ text: String) {
        percentage.text = text
    }
    
    func setAdditionalText(_ text: String) {
        statisticType.text = text
    }
}
