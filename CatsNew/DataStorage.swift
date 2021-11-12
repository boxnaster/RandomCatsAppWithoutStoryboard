//
//  DataStorage.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 16.10.2021.
//

import Foundation
import UIKit

class DataStorage {

    private let cats =
    [CatModel(catId: 1, name: "Pirozhok", image: UIImage(named: "cat1.svg"), isLiked: false, breeds: ["British", "Siamese"], category: "boxes"),
    CatModel(catId: 2, name: "Kuzya", image: UIImage(named: "cat2.svg"), isLiked: false, breeds: ["Scottish"], category: "space"),
    CatModel(catId: 3, name: "Bulka", image: UIImage(named: "cat3.svg"), isLiked: false, breeds: ["Russian blue", "British"], category: "boxes"),
    CatModel(catId: 4, name: "Musya", image: UIImage(named: "cat4.svg"), isLiked: false, breeds: ["Siamese"], category: "smth"),
    CatModel(catId: 5, name: "Baton", image: UIImage(named: "cat5.svg"), isLiked: false, breeds: ["Simple", "Scottish"], category: "space")]


    static public var selectedBreeds: [Breed] = []

    static public var selectedCategory: Category?

    static public var selectedBreedRows: [Int] = []

    static public var selectedCategoryRow: Int?

    func getCats() -> [CatModel] {
        return cats
    }
}
