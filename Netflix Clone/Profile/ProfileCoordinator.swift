//
//  ProfileCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class ProfileCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var sender: UIViewController
    
    init(navigationController: UINavigationController, sender: UIViewController) {
        self.navigationController = navigationController
        self.sender = sender
    }
    
    func start() {
        let vc = ProfileViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentSignOut(sender: ProfileViewController) {
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak sender] _ in
            guard let strongSender = sender else {return}
            Task {
                try await AuthManager.shared.logOut()
                let child = OnboardingCoordinator(navigationController: self.navigationController, sender: strongSender)
                self.childCoordinators.append(child)
                child.start()
            }
        }))
        sender.present(alert, animated: true)
    }
}

extension ProfileCoordinator: UINavigationControllerDelegate {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {return}
        if navigationController.viewControllers.contains(fromViewController) {return}
        
        if let loginVC = fromViewController as? LoginViewController {
            childDidFinish(loginVC.coordinator)
        }
    }
}
