//
//  RequestBuilder.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//
import Foundation


struct RequestBuilder {
    private var baseURL: URL
    private var route: Route
    private var headers: [String: String] = [:]
    
    init(route: Route) {
        self.baseURL = URL(string: ApiEnvironment.current.baseUrl)!
        self.route = route
        self.headers = ApiEnvironment.current.headers
    }
    
    mutating func addHeader(key: String, value: String) -> RequestBuilder {
        headers[key] = value
        return self
    }

    func build() -> URLRequest? {
        // Build the full URL with path and query parameters
        var components = URLComponents(url: baseURL.appendingPathComponent(route.path), resolvingAgainstBaseURL: true)
        components?.queryItems = route.queryItems
        
        guard let url = components?.url else { return nil }
        
        // Build the request
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        request.timeoutInterval = ApiEnvironment.current.timeout
        
        // Add headers
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // If there's a body, encode it as JSON
        if let body = route.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if ApiEnvironment.current.shouldPrintDebugLog {
            print("🚀 Request: \(request.httpMethod ?? "Unknown Method") \(url.absoluteString)")
            if let body = route.body {
                print("📦 Body: \(body)")
            }
            if !headers.isEmpty {
                print("📝 Headers: \(headers)")
            }
        }
        
        return request
    }
}
