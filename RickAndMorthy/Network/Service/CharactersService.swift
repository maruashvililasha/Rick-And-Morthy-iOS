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

