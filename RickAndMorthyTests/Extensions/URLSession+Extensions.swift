//
//  URLSession+Extensions.swift
//  RickAndMorthyTests
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation
@testable import RickAndMorthy

extension URLSession {
    static var mockSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var responseCode: Int = 200
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let data = MockURLProtocol.mockData {
            let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.responseCode, httpVersion: nil, headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.responseCode, httpVersion: nil, headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didFailWithError: APIError.invalidResponse)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Nothing to do here
    }
}
