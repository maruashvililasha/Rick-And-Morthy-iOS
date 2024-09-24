//
//  Constants.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

enum ApiEnvironment {
    case production
    case staging
    
    static var current: ApiEnvironment {
        .staging
    }
    
    var shouldPrintDebugLog: Bool {
        switch self {
        case .production:
            return false
        case .staging:
            return true
        }
    }
    
    var baseUrl: String {
        switch self {
        case .production:
            return "https://rickandmortyapi.com/api"
        case .staging:
            return "https://rickandmortyapi.com/api"
        }
    }
    
    var apiKey: String {
        switch self {
        case .production:
            return ""
        case .staging:
            return ""
        }
    }
    
    var timeout: TimeInterval {
        switch self {
        case .production:
            return 10
        case .staging:
            return 10
        }
    }
    
    var headers: [String: String] {
//        ["Authorization": "Bearer \(apiKey)"]
        [:]
    }
}
