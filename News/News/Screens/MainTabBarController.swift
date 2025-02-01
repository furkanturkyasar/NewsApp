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

        newsListVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), tag: 1)

        viewControllers = [newsListVC, settingsVC]
    }
}
