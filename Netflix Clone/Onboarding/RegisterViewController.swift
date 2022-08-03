//
//  RegisterViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/31/22.
//

import UIKit

protocol RegisterViewControllerDelegate: AnyObject {
    func didRegisterSuccessfully()
}

class RegisterViewController: UIViewController {
    
//MARK: - Properties
    weak var coordinator: OnboardingCoordinator?
    weak var delegate: RegisterViewControllerDelegate?
    private var image: UIImage?
    
//MARK: - SubViews
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = K.profileImageSize/2
        imageView.isUserInteractionEnabled = true
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
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
//MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        addSubviews()
        configureConstraints()
        configureTextFields()
        addActions()
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
    }
    
//MARK: - Configure
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(tap)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        let tap2 = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap2)
    }

//MARK: - Actions
    @objc private func didTapProfileImage() {
        coordinator?.presentImagePicker(sender: self)
    }
    
    @objc private func didTapClose() {
        coordinator?.dismissRegisterScreen(sender: self)
    }
    
    @objc private func didTapRegisterButton() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let email = emailField.text,
              let username = usernameField.text,
              let password = passwordField.text,
              let image = self.image,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@") && email.contains(".com"),
              password.count >= 4 else {return}
              
        Task {
            try await OnboardingViewModel.register(username: username, email: email, password: password)
            try await OnboardingViewModel.uploadProfilePicture(username: username, data: image.pngData())
            didTapClose()
            delegate?.didRegisterSuccessfully()
        }
    }
}

//MARK: - ImagePicker Methods
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.image = image
        profileImageView.image = image
    }
}

//MARK: - TextField Methods
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

//MARK: - Constraints
extension RegisterViewController {
    private func configureConstraints() {
        let size: CGFloat = 200
        
        let profileImageViewConstraints = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: K.profileImageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: K.profileImageSize)
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
