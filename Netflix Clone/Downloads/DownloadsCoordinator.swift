//
//  DownloadsCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class DownloadsCoordinator: Coordinator {
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
    
    func tappedOnCell(sender: DownloadsViewController, model: TitlePreviewModel) {
        let vc = TitlePreviewViewController()
        vc.configure(with: model)
        let navVC = UINavigationController(rootViewController: vc)
        sender.present(navVC, animated: true)
    }
}
