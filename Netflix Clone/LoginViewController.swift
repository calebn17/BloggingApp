//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

class LoginViewController: UIViewController {

    private let emailField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "Enter your email..."
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        return field
    }()
    
    private let passwordField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "Enter you password..."
        field.keyboardType = .default
        field.returnKeyType = .done
        return field
    }()
    
    private let button: CustomButton = {
        let button = CustomButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        emailField.delegate = self
        passwordField.delegate = self
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func addSubViews() {
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
    }
    
    @objc private func didTapButton() {
        //Sign in
        
        // If sign in is successful
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
        return true
    }
}
