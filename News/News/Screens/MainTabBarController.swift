//
//  MainTabBarController.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func configure() {
        let newsListVC = UINavigationController(rootViewController: NewsListViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())

        newsListVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tabbar.News", comment: ""),
            image: UIImage(systemName: "newspaper.fill"), tag: 0
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tabbar.Settings", comment: ""),
            image: UIImage(systemName: "gear"), tag: 1
        )

        viewControllers = [newsListVC, settingsVC]
    }
}
