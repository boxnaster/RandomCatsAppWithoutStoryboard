//
//  Category.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 02.11.2021.
//

import Foundation

class Category {
    public let identifier: String
    public let name: String

    init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}
