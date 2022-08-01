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
    let sender: AnyObject
    
    init(navigationController: UINavigationController, sender: AnyObject) {
        self.navigationController = navigationController
        self.sender = sender
    }
    
    func start() {
        let vc = LoginViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        sender.present(vc, animated: true)
    }
    
    func presentRegisterScreen(sender: LoginViewController) {
        print("coordinator recieved register event")
        let vc = RegisterViewController()
        vc.coordinator = self
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
}
