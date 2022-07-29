//
//  PreviewCoordinator.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 7/29/22.
//

import Foundation
import UIKit

final class PreviewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var viewModel: TitlePreviewModel
    var sender: AnyObject
    
    init(navigationController: UINavigationController, sender: AnyObject, viewModel: TitlePreviewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.sender = sender
    }
    
    func start() {
        let vc = TitlePreviewViewController()
        vc.coordinator = self
        vc.configure(with: viewModel)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        sender.present(navVC, animated: true)
    }
    
    
}
