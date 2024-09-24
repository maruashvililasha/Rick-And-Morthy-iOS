//
//  NasaService.swift
//  NetworkApp
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Combine
import Foundation

protocol CharactersServiceType: APIClient {
    func getCharacters(page: Int?) -> AnyPublisher<BaseResponse<[Character]>, APIError>
    func getCharacter(id: Int) -> AnyPublisher<Character, APIError>
}

class CharactersService: CharactersServiceType {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCharacters(page: Int?) -> AnyPublisher<BaseResponse<[Character]>, APIError> {
        let route = API.Characters.getCharacters(page: page)
        let requestBuilder = RequestBuilder(route: route)
        
        guard let request = requestBuilder.build() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sendRequest(request: request)
    }
    
    func getCharacter(id: Int) -> AnyPublisher<Character, APIError> {
        let route = API.Characters.getCharacter(id: id)
        let requestBuilder = RequestBuilder(route: route)
        
        guard let request = requestBuilder.build() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sendRequest(request: request)
    }
}

class MockCharactersService: CharactersServiceType {
    var session: URLSession = .shared
    
    var mockCharacters: [Character] = []
    var mockCharacter: Character?
    var error: APIError?
    
    func getCharacters(page: Int?) -> AnyPublisher<BaseResponse<[Character]>, APIError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            let response = BaseResponse(info: Info(count: mockCharacters.count, pages: 1, next: nil, prev: nil), results: mockCharacters)
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }

    func getCharacter(id: Int) -> AnyPublisher<Character, APIError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let character = mockCharacter {
            return Just(character)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: .invalidResponse).eraseToAnyPublisher()
        }
    }
}
