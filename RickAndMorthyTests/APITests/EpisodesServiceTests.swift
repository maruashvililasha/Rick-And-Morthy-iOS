//
//  EpisodesServiceTests.swift
//  RickAndMorthyTests
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import XCTest
import Combine
@testable import RickAndMorthy

class EpisodesServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockService: EpisodesService!
    
    override func setUpWithError() throws {
        cancellables = []
        mockService = EpisodesService(session: .mockSession)
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        mockService = nil
    }
    
    // Test fetching episodes successfully
    func testFetchEpisodesSuccess() {
        // Load mock data from GetEpisodes.json
        let mockEpisodesData = loadJSONDataFromFile(named: "GetEpisodes")
        
        // Set the mock data in MockURLProtocol
        MockURLProtocol.mockData = mockEpisodesData
        MockURLProtocol.responseCode = 200
        
        let expectation = XCTestExpectation(description: "Fetch episodes successfully")
        
        // Perform the API call
        mockService.getEpisodes(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API call failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                XCTAssertFalse(response.results.isEmpty, "No episodes were fetched")
                XCTAssertEqual(response.results.first?.name, "Pilot", "First episode should be Pilot")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Test failure while fetching episodes
    func testFetchEpisodesFailure() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.responseCode = 500
        
        let expectation = XCTestExpectation(description: "Handle failure while fetching episodes")
        
        mockService.getEpisodes(page: 1)
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
    
    // Test fetching a single episode successfully
    func testFetchSingleEpisodeSuccess() {
        let mockEpisodeData = loadJSONDataFromFile(named: "Episode")
        
        MockURLProtocol.mockData = mockEpisodeData
        MockURLProtocol.responseCode = 200
        
        let expectation = XCTestExpectation(description: "Fetch a single episode successfully")
        
        // Perform the API call
        mockService.getEpisode(id: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API call failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { episode in
                XCTAssertEqual(episode.name, "Pilot", "Episode should be Pilot")
                XCTAssertEqual(episode.id, 1, "Episode ID should be 1")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // Test failure while fetching a single episode
    func testFetchSingleEpisodeFailure() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.responseCode = 404
        
        let expectation = XCTestExpectation(description: "Handle failure while fetching a single episode")
        
        mockService.getEpisode(id: 9999) // Invalid episode ID
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
        let bundle = Bundle(for: CharactersServiceTests.self)
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
