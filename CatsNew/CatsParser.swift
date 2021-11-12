//
//  SearchCatsParser.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 02.11.2021.
//

import Foundation
import UIKit

internal class CatsParser {

    internal enum Error: Swift.Error {
        case invalidResponse
        case unexpectedStatuscode
        case cantParseResponse
    }

    internal static func parseCats(responseData: Data?, response: URLResponse?, error: Swift.Error?) -> Swift.Result<[Cat], Swift.Error> {
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

    internal static func parseCat(responseData: Data?, response: URLResponse?, error: Swift.Error?) -> Swift.Result<Cat, Swift.Error> {
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
            guard let rawItem = responseJSON as? [String: Any]
            else {
                return .failure(Error.cantParseResponse)
            }
            let item = try? parseItem(rawItem: rawItem)
            return .success(item!)
        } catch let jsonError {
            return .failure(jsonError)
        }
    }

    private static func parseItem(rawItem: [String: Any]) throws -> Cat {
        guard let identifier = rawItem["id"] as? String,
              let url = rawItem["url"] as? String,
              let width = rawItem["width"] as? Int,
              let height = rawItem["height"] as? Int
        else {
            throw Error.cantParseResponse
        }
        let rawCategories = rawItem["categories"] as? [[String: Any]] ?? []
        let rawBreeds = rawItem["breeds"] as? [[String: Any]] ?? []
        let categories = rawCategories.compactMap { try? CategoriesParser.parseItem(rawItem: $0) }
        let breeds = rawBreeds.compactMap { try? BreedsParser.parseItem(rawItem: $0) }
        return Cat(identifier: identifier,
                   url: url,
                   width: width,
                   height: height,
                   image: UIImage(),
                   breeds: breeds,
                   categories: categories)
    }
}
