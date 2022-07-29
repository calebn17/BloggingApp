
//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Caleb Ngai on 4/27/22.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let home = HomeCoordinator(navigationController: UINavigationController())
    let upcoming = UpcomingCoordinator(navigationController: UINavigationController())
    let search = SearchCoordinator(navigationController: UINavigationController())
    let downloads = DownloadsCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        home.start()
        upcoming.start()
        search.start()
        downloads.start()
        
        let nav1 = home.navigationController
        let nav2 = upcoming.navigationController
        let nav3 = search.navigationController
        let nav4 = downloads.navigationController
        
        nav1.navigationBar.tintColor = .white
        nav2.navigationBar.tintColor = .white
        nav3.navigationBar.tintColor = .white
        nav4.navigationBar.tintColor = .white
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Coming Soon", image: UIImage(systemName: "play.circle"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Top Searches", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 1)
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: false)
        
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().tintColor = .label
    }
}

