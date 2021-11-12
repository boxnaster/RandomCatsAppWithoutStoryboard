//
//  Category.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 02.11.2021.
//

import Foundation

class Category {
    public let identifier: Int
    public let name: String

    init(identifier: Int, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
