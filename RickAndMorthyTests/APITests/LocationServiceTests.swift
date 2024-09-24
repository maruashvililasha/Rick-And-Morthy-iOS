//
//  LocationServiceTests.swift
//  RickAndMorthyTests
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import XCTest
import Combine
@testable import RickAndMorthy

class LocationsServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockService: LocationsService!
    
    override func setUpWithError() throws {
        cancellables = []
        mockService = LocationsService(session: .mockSession)
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        mockService = nil
    }
    
    // Test fetching locations successfully
    func testFetchLocationsSuccess() {
        // Load mock data from GetLocations.json
        let mockLocationsData = loadJSONDataFromFile(named: "GetLocations")
        
        // Set the mock data in MockURLProtocol
        MockURLProtocol.mockData = mockLocationsData
        MockURLProtocol.responseCode = 200
        
        let expectation = XCTestExpectation(description: "Fetch locations successfully")
        
        // Perform the API call
        mockService.getLocations(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API call failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                XCTAssertFalse(response.results.isEmpty, "No locations were fetched")
                XCTAssertEqual(response.results.first?.name, "Earth (C-137)", "First location should be Earth (C-137)")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Test failure while fetching locations
    func testFetchLocationsFailure() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.responseCode = 500
        
        let expectation = XCTestExpectation(description: "Handle failure while fetching locations")
        
        mockService.getLocations(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    //MARK: - Helpers
    func loadJSONDataFromFile(named fileName: String) -> Data {
        let bundle = Bundle(for: LocationsServiceTests.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Unable to locate \(fileName).json in the test bundle.")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Unable to load \(fileName).json: \(error)")
        }
    }
}
