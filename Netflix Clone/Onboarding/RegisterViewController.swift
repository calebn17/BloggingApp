//
//  RegisterViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    weak var coordinator: OnboardingCoordinator?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameField: CustomTextField = {
        let field = CustomTextField()
        field.placeholder = "Enter your username..."
        field.keyboardType = .default
        field.returnKeyType = .next
        return field
    }()
    
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
    
    private let registerButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        addSubviews()
        configureConstraints()
        configureTextFields()
        
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
    }
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    private func configureTextFields() {
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    private func addActions() {
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
  
    @objc private func didTapClose() {
        coordinator?.dismissRegisterScreen(sender: self)
    }
    
    @objc private func didTapRegisterButton() {
        //Register user
        
        //dismiss register screen
        didTapClose()
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            resignFirstResponder()
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            resignFirstResponder()
            didTapRegisterButton()
        }
        return true
    }
}

extension RegisterViewController {
    private func configureConstraints() {
        let size: CGFloat = 200
        
        let profileImageViewConstraints = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        let usernameFieldConstraints = [
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameField.heightAnchor.constraint(equalToConstant: 40),
            usernameField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: size),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(usernameFieldConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
