//
//  AuthenticationRoute.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

extension API {
    enum Characters: Route {
        case getCharacters(page: Int?)
        case getCharacter(id: Int)

        var path: String {
            switch self {
            case .getCharacters:
                return "character"
            case .getCharacter(let id):
                return "character/\(id)"
            }
        }

        var queryItems: [URLQueryItem]? {
            switch self {
            case .getCharacters(let page):
                if let page = page {
                    return [URLQueryItem(name: "page", value: String(page))]
                }
                return nil
            case .getCharacter:
                return nil
            }
        }

        var body: [String: Any]? {
            return nil
        }

        var method: HTTPMethod {
            switch self {
            case .getCharacters:
                return .get
            case .getCharacter:
                return .get
            }
        }
    }
}
