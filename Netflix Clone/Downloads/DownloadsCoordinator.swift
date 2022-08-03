//
//  DownloadsCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class DownloadsCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = DownloadsViewController()
        vc.coordinator = self
        vc.title = "Downloads"
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentPreview(sender: DownloadsViewController, model: TitlePreviewModel) {
        let child = PreviewCoordinator(navigationController: navigationController, sender: sender, viewModel: model)
        childCoordinators.append(child)
        child.start()
    }
}

extension DownloadsCoordinator: UINavigationControllerDelegate {
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
