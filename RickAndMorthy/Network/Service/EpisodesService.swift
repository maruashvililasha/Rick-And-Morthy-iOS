//
//  EpisodesService.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation
import Combine

protocol EpisodesServiceProtocol: APIClient {
    func getEpisodes(page: Int?) -> AnyPublisher<BaseResponse<[Episode]>, APIError>
    func getEpisode(id: Int) -> AnyPublisher<Episode, APIError>
}

class EpisodesService: EpisodesServiceProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getEpisodes(page: Int?) -> AnyPublisher<BaseResponse<[Episode]>, APIError> {
        let route = API.Episodes.getEpisodes(page: page)
        let requestBuilder = RequestBuilder(route: route)
        
        guard let request = requestBuilder.build() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sendRequest(request: request)
    }
    
    func getEpisode(id: Int) -> AnyPublisher<Episode, APIError> {
        let route = API.Episodes.getEpisode(id: id)
        let requestBuilder = RequestBuilder(route: route)
        
        guard let request = requestBuilder.build() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sendRequest(request: request)
    }
}

