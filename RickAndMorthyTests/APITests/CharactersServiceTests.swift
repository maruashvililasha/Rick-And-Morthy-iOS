//
//  RickAndMortyServiceTests.swift
//  RickAndMorthyTests
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import XCTest
import Combine
@testable import RickAndMorthy

class CharactersServiceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockService: CharactersService!
    
    override func setUpWithError() throws {
        cancellables = []
        mockService = CharactersService(session: .mockSession)
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        mockService = nil
    }
    
    func testFetchCharactersSuccess() {
        // Load mock data from GetCharacters.json
        let mockCharactersData = loadJSONDataFromFile(named: "GetCharacters")
        
        // Set the mock data in MockURLProtocol
        MockURLProtocol.mockData = mockCharactersData
        MockURLProtocol.responseCode = 200
        
        let expectation = XCTestExpectation(description: "Fetch characters successfully")
        
        // Perform the API call
        mockService.getCharacters(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API call failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                XCTAssertFalse(response.results.isEmpty, "No characters were fetched")
                XCTAssertEqual(response.results.first?.name, "Rick Sanchez", "First character should be Rick Sanchez")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCharactersFailure() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.responseCode = 500
        
        let expectation = XCTestExpectation(description: "Handle failure while fetching characters")
        mockService.getCharacters(page: 1)
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
    
    func testFetchSingleCharacterSuccess() {
        let mockCharacterData = loadJSONDataFromFile(named: "Character")
        
        MockURLProtocol.mockData = mockCharacterData
        MockURLProtocol.responseCode = 200
        
        let expectation = XCTestExpectation(description: "Fetch a single character successfully")
        
        // Perform the API call
        mockService.getCharacter(id: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("API call failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { character in
                XCTAssertEqual(character.name, "Rick Sanchez", "Character should be Rick Sanchez")
                XCTAssertEqual(character.id, 1, "Character ID should be 1")
                XCTAssertEqual(character.species, "Human", "Character species should be Human")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchSingleCharacterFailure() {
        MockURLProtocol.mockData = nil
        MockURLProtocol.responseCode = 404
        
        let expectation = XCTestExpectation(description: "Handle failure while fetching a single character")
        
        mockService.getCharacter(id: 9999) // Invalid character ID
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
