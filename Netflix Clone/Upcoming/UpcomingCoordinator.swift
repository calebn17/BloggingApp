//
//  UpcomingCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class UpcomingCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = UpcomingViewController()
        vc.title = "Upcoming"
        vc.coordinator = self
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.navigationBar.tintColor = .white
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentPreview(sender: UpcomingViewController, model: TitlePreviewViewModel) {
        let child = PreviewCoordinator(navigationController: navigationController, sender: sender, viewModel: model)
        childCoordinators.append(child)
        child.start()
    }
}

extension UpcomingCoordinator: UINavigationControllerDelegate {
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
        
        if let previewVC = fromViewController as? TitlePreviewViewController {
            childDidFinish(previewVC.coordinator)
        }
    }
}
