//
//  ReusableTextField.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

class CustomTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        leftViewMode = .always
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.borderWidth = 1
        textAlignment = .natural
        backgroundColor = .systemBackground
        autocorrectionType = .no
        autocapitalizationType = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
