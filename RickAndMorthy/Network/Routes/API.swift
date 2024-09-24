//
//  API.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

enum API {
    static func createQueryItems(from queryParams: [String: String]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        for (key, value) in queryParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        return queryItems
    }
}
