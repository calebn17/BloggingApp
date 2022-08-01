//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

class LoginViewController: UIViewController {

//MARK: - Properties
    
    weak var coordinator: OnboardingCoordinator?

//MARK: - Subviews
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
    
    private let loginButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Don't have an account? Register here!", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        configureConstraints()
        emailField.delegate = self
        passwordField.delegate = self
        loginButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func addSubViews() {
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
//MARK: - Actions
    @objc private func didTapButton() {
        //Sign in
        
        // If sign in is successful
        coordinator?.dismissLoginScreen(sender: self)
    }
    
    @objc private func didTapRegisterButton() {
        print("register button tapped")
        coordinator?.presentRegisterScreen(sender: self)
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

extension LoginViewController {
    private func configureConstraints() {
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            emailField.heightAnchor.constraint(equalToConstant: 40)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            passwordField.heightAnchor.constraint(equalToConstant: 40)
        ]
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            registerButton.widthAnchor.constraint(equalToConstant: 400)
        ]
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
