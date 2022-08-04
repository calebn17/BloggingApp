//
//  HomeCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class HomeCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = HomeViewController()
        vc.coordinator = self
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentLoginScreen(sender: HomeViewController) {
        let child = OnboardingCoordinator(navigationController: navigationController, sender: sender)
        childCoordinators.append(child)
        child.start()
    }
    
    func presentPreview(viewModel: TitlePreviewViewModel, sender: HomeViewController) {
        let child = PreviewCoordinator(navigationController: navigationController, sender: sender, viewModel: viewModel)
        childCoordinators.append(child)
        child.start()
    }
    
    func pushProfileScreen(sender: HomeViewController) {
        let child = ProfileCoordinator(navigationController: navigationController, sender: sender)
        childCoordinators.append(child)
        child.start()
    }
    
}

extension HomeCoordinator: UINavigationControllerDelegate {
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
        else if let previewVC = fromViewController as? TitlePreviewViewController {
            childDidFinish(previewVC.coordinator)
        }
        else if let profileVC = fromViewController as? ProfileViewController {
            childDidFinish(profileVC.coordinator)
        }
    }
}
