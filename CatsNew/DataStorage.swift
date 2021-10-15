//
//  DataStorage.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 16.10.2021.
//

import Foundation
import UIKit

class DataStorage {

    private var cats =
    [CatModel(catId: 1, name: "Pirozhok", image: UIImage(named: "cat1.svg"), isLiked: false, breeds: ["British", "Siamese"], category: "category"),
    CatModel(catId: 2, name: "Kuzya", image: UIImage(named: "cat2.svg"), isLiked: false, breeds: ["Scottish"], category: "category"),
    CatModel(catId: 3, name: "Bulka", image: UIImage(named: "cat3.svg"), isLiked: false, breeds: ["Russian blue", "British"], category: "category"),
    CatModel(catId: 4, name: "Musya", image: UIImage(named: "cat4.svg"), isLiked: false, breeds: ["Siamese"], category: "category"),
    CatModel(catId: 5, name: "Baton", image: UIImage(named: "cat5.svg"), isLiked: false, breeds: ["Simple", "Scottish"], category: "category")]

    func getCats() -> [CatModel] {
        return cats
    }
}
