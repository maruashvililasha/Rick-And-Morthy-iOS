//
//  LocationsService.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Combine
import Foundation

protocol LocationServiceType: APIClient {
    func getLocations(page: Int?) -> AnyPublisher<BaseResponse<[Location]>, APIError>
}

class LocationsService: LocationServiceType {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getLocations(page: Int?) -> AnyPublisher<BaseResponse<[Location]>, APIError> {
        let route = API.Location.getLocations(page: page)
        let requestBuilder = RequestBuilder(route: route)
        
        guard let request = requestBuilder.build() else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return sendRequest(request: request)
    }
}

