//
//  TabBarController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 13.10.2021.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {

        super.viewDidLoad()

        let searchViewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: searchViewController)
        let navigationControllerTabBatItem = UITabBarItem(title: "Search",
                                                          image: UIImage(named: "search.svg"),
                                                          selectedImage: UIImage(named: "search.svg"))

        navigationController.tabBarItem = navigationControllerTabBatItem

        let uploadViewController = UploadViewController()
        let uploadViewControllerTabBarItem = UITabBarItem(title: "Upload",
                                                          image: UIImage(named: "plus-circle.svg"),
                                                          selectedImage: UIImage(named: "plus-circle.svg"))

        uploadViewController.tabBarItem = uploadViewControllerTabBarItem

        let favouritesViewController = FavouritesViewController()
        let favouritesViewControllerTabBarItem = UITabBarItem(title: "Favourites",
                                                              image: UIImage(named: "small-heart.svg"),
                                                              selectedImage: UIImage(named: "small-heart.svg"))

        favouritesViewController.tabBarItem = favouritesViewControllerTabBarItem

        self.viewControllers = [navigationController, uploadViewController, favouritesViewController]
    }
}
