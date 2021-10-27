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
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let searchNavigationControllerTabBatItem = UITabBarItem(title: "Search",
                                                                image: UIImage(named: "search.svg"),
                                                                selectedImage: UIImage(named: "search.svg"))

        searchNavigationController.tabBarItem = searchNavigationControllerTabBatItem

        let uploadViewController = UploadViewController()
        let uploadNavigationController = UINavigationController(rootViewController: uploadViewController)
        let uploadNavigationControllerTabBarItem = UITabBarItem(title: "Upload",
                                                                image: UIImage(named: "plus-circle.svg"),
                                                                selectedImage: UIImage(named: "plus-circle.svg"))

        uploadNavigationController.tabBarItem = uploadNavigationControllerTabBarItem

        let favouritesViewController = FavouritesViewController()
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
        let favouritesNavigationControllerTabBarItem = UITabBarItem(title: "Favourites",
                                                                    image: UIImage(named: "small-heart.svg"),
                                                                    selectedImage: UIImage(named: "small-heart.svg"))

        favouritesNavigationController.tabBarItem = favouritesNavigationControllerTabBarItem

        self.viewControllers = [searchNavigationController, uploadNavigationController, favouritesNavigationController]
    }
}
