//
//  ProductRoute.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

extension API {
    enum Location: Route {
        case getLocations(page: Int?)

        var path: String {
            switch self {
            case .getLocations:
                return "location"
            }
        }

        var queryItems: [URLQueryItem]? {
            switch self {
            case .getLocations(let page):
                if let page = page {
                    return [URLQueryItem(name: "page", value: String(page))]
                }
                return nil
            }
        }

        var body: [String: Any]? {
            return nil
        }

        var method: HTTPMethod {
            switch self {
            case .getLocations:
                return .get
            }
        }
    }
}
