//
//  OrderRoute.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation


extension API {
    enum Episodes: Route {
        case getEpisodes(page: Int?)
        case getEpisode(id: Int)

        var path: String {
            switch self {
            case .getEpisodes:
                return "episode"
            case .getEpisode(let id):
                return "episode/\(id)"
            }
        }

        var queryItems: [URLQueryItem]? {
            switch self {
            case .getEpisodes(let page):
                if let page = page {
                    return [URLQueryItem(name: "page", value: String(page))]
                }
                return nil
            case .getEpisode:
                return nil
            }
        }

        var body: [String: Any]? {
            return nil
        }

        var method: HTTPMethod {
            switch self {
            case .getEpisodes:
                return .get
            case .getEpisode:
                return .get
            }
        }
    }
}
