//
//  CustomButton.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        backgroundColor = .systemBackground
        layer.masksToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
