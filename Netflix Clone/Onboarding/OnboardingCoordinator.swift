//
//  OnboardingCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 8/1/22.
//

import Foundation
import UIKit

final class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let sender: UIViewController
    
    init(navigationController: UINavigationController, sender: UIViewController) {
        self.navigationController = navigationController
        self.sender = sender
    }
    
    func start() {
        let vc = LoginViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        sender.present(vc, animated: true) { [weak sender] in
            sender?.navigationController?.popToRootViewController(animated: false)
            sender?.tabBarController?.selectedIndex = 0
        }
    }
    
    func presentRegisterScreen(sender: LoginViewController) {
        let vc = RegisterViewController()
        vc.coordinator = self
        vc.delegate = sender
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true)
    }
    
    func dismissLoginScreen(sender: LoginViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    func dismissRegisterScreen(sender: RegisterViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(sender: RegisterViewController) {
        let sheet = UIAlertController(title: "Select Profile Image", message: "Please select your profile image", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { [weak sender] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = sender
                sender?.present(picker, animated: true, completion: nil)
            }
        }))
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { [weak sender] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = sender
                sender?.present(picker, animated: true)
            }
        }))
        sender.present(sheet, animated: true)
    }
}
