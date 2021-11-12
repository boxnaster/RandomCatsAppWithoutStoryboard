//
//  CategoriesParser.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 05.11.2021.
//

import Foundation
import UIKit

internal class CategoriesParser {

    internal enum Error: Swift.Error {
        case invalidResponse
        case unexpectedStatuscode
        case cantParseResponse
    }

    internal static func parseCategories(responseData: Data?, response: URLResponse?, error: Swift.Error?) -> Swift.Result<[Category], Swift.Error> {
        if let realError = error {
            return .failure(realError)
        }

        guard let httpResponse = response as? HTTPURLResponse, let realData = responseData else {
            return .failure(Error.invalidResponse)
        }

        guard httpResponse.statusCode == 200 else {
            return .failure(Error.unexpectedStatuscode)
        }

        do {
            let responseJSON = try JSONSerialization.jsonObject(with: realData, options: [])
            guard let rawItems = responseJSON as? [[String: Any]]
            else {
                return .failure(Error.cantParseResponse)
            }
            let items = rawItems.compactMap { try? parseItem(rawItem: $0) }
            return .success(items)
        } catch let jsonError {
            return .failure(jsonError)
        }
    }

    public static func parseItem(rawItem: [String: Any]) throws -> Category {
        guard let identifier = rawItem["id"] as? Int,
              let name = rawItem["name"] as? String
        else {
            throw Error.cantParseResponse
        }
        return Category(identifier: identifier,
                        name: name)
    }
}
