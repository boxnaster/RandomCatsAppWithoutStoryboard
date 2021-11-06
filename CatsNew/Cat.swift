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

    init(identifier: String, url: String, width: Int, height: Int, image: UIImage) {
        self.identifier = identifier
        self.url = url
        self.width = width
        self.height = height
        self.image = image
    }
}
