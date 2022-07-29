//
//  SearchCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import UIKit

final class SearchCoordinator: Coordinator {
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
    
    func tappedOnSearchCell(sender: SearchViewController, model: TitlePreviewModel) {
        let vc = TitlePreviewViewController()
        vc.configure(with: model)
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true)
    }
}
