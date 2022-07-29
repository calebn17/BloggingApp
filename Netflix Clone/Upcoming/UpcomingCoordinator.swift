//
//  UpcomingCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class UpcomingCoordinator: Coordinator {
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
        navigationController.pushViewController(vc, animated: false)
    }
    
    func tappedCell(sender: UpcomingViewController, model: TitlePreviewModel) {
        let vc = TitlePreviewViewController()
        vc.configure(with: model)
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true)
    }
}
