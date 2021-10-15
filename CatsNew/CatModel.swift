//
//  CatModel.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 15.10.2021.
//

import Foundation
import UIKit

class CatModel {

    public let catId: Int
    public let name: String
    public let image: UIImage?
    public var isLiked: Bool
    public let breeds: [String]
    public let category: String

    init(catId: Int, name: String, image: UIImage?, isLiked: Bool, breeds: [String], category: String) {
        self.catId = catId
        self.name = name
        self.image = image
        self.isLiked = isLiked
        self.breeds = breeds
        self.category = category
    }
}
