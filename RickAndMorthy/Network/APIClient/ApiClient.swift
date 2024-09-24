//
//  ApiClient.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//
import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Route {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var method: HTTPMethod { get }
}

protocol APIClient {
    var session: URLSession { get }
    
    func sendRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, APIError>
}

extension APIClient {
    func sendRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, APIError> {
        session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if ApiEnvironment.current.shouldPrintDebugLog, let httpResponse = response as? HTTPURLResponse {
                    print("✅ Response: \(httpResponse.statusCode) for \(request.url?.absoluteString ?? "")")
                    let shouldPrintResponse = false
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []), shouldPrintResponse {
                        print("📩 Response Body: \(json)")
                    }
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if ApiEnvironment.current.shouldPrintDebugLog {
                    print("❌ Error: \(error.localizedDescription) for \(request.url?.absoluteString ?? "")")
                }
                if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return .networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

enum API {
    // Here will go All ApiRoutes
}
