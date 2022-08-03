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
        // Calling to main thread because Profile Coordinator invokes this method in a Task
        DispatchQueue.main.async {[weak self] in
            let vc = LoginViewController()
            vc.coordinator = self
            vc.modalPresentationStyle = .fullScreen
            self?.sender.present(vc, animated: true) {
                self?.sender.navigationController?.popToRootViewController(animated: false)
                self?.sender.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    func presentRegisterScreen(sender: LoginViewController) {
        print("coordinator recieved register event")
        let vc = RegisterViewController()
        vc.coordinator = self
        vc.delegate = sender
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
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
