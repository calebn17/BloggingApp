//
//  SearchCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import UIKit

final class SearchCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController()
        vc.coordinator = self
        vc.title = "Search"
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentPreview(sender: SearchViewController, model: TitlePreviewModel) {
        let child = PreviewCoordinator(navigationController: navigationController, sender: sender, viewModel: model)
        childCoordinators.append(child)
        child.start()
    }
}

extension SearchCoordinator: UINavigationControllerDelegate {
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
        
        if let previewVC = fromViewController as? LoginViewController {
            childDidFinish(previewVC.coordinator)
        }
    }
}
