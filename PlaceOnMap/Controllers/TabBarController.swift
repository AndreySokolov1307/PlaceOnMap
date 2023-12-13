//
//  TabBarController.swift
//  GdeYaPokakal
//
//  Created by Андрей Соколов on 24.11.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
        setupTabBarAppereance()
    }
    
    private func setupTabs() {
        let home = createNavigationController(with: "Дом", image: UIImage(systemName: "square")!, vc: HomeViewController())
        let map = createNavigationController(with: "Карта", image: UIImage(systemName: "circle")!, vc: MapViewController())
        let statistic = createNavigationController(with: "Список", image: UIImage(systemName: "photo")!, vc: ShitListTableViewController())
        
        self.setViewControllers([home, map, statistic], animated: true)
    }
    
    private func setupTabBarAppereance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .quaternarySystemFill
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createNavigationController(with title: String, image: UIImage, vc: UIViewController) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: vc)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
       // navController.navigationBar.prefersLargeTitles = true
        navController.viewControllers.first!.navigationItem.title = title
        
        return navController
    }
}

//MARK: - Orientation

extension TabBarController {
    override var shouldAutorotate: Bool {
        if selectedIndex == 0 {
            return false
        } else {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if selectedIndex == 0 {
            return UIInterfaceOrientationMask.portrait
        } else  {
            return UIInterfaceOrientationMask.all
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}
