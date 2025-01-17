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
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.clipsToBounds = true
        logo.image = UIImage(named: "netflixLogo3x")
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
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
        field.isSecureTextEntry = true
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
        addActions()
        
    }
    
    private func addSubViews() {
        view.addSubview(logo)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func addActions() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
//MARK: - Actions
    @objc private func didTapLoginButton() {
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@") && email.contains(".com"),
              password.count >= 4 else {return}
        
        Task {
            try await OnboardingViewModel.signIn(email: email, password: password)
            coordinator?.dismissLoginScreen(sender: self)
        }
    }
    
    @objc private func didTapRegisterButton() {
        coordinator?.presentRegisterScreen(sender: self)
    }
}

//MARK: - Register VC Methods
extension LoginViewController: RegisterViewControllerDelegate {
    func didRegisterSuccessfully() {
        coordinator?.dismissLoginScreen(sender: self)
    }
}

//MARK: - Text Field Methods
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            resignFirstResponder()
            didTapLoginButton()
        }
        return true
    }
}

//MARK: - Constraints
extension LoginViewController {
    private func configureConstraints() {
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 200)
        ]
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 100),
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
        NSLayoutConstraint.activate(logoConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
