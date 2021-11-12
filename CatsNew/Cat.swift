//
//  Cat.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 02.11.2021.
//

import Foundation
import UIKit

class Cat {
    public let identifier: String
    public let url: String
    public let width: Int
    public let height: Int
    public var image: UIImage
    public let breeds: [Breed]
    public let categories: [Category]

    init(identifier: String, url: String, width: Int, height: Int, image: UIImage, breeds: [Breed], categories: [Category]) {
        self.identifier = identifier
        self.url = url
        self.width = width
        self.height = height
        self.image = image
        self.breeds = breeds
        self.categories = categories
    }
}
