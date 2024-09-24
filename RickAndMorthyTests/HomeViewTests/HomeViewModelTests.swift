//
//  HomeViewModelTests.swift
//  RickAndMorthyTests
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import XCTest
import Combine
@testable import RickAndMorthy

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockService: MockCharactersService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockService = MockCharactersService()
        viewModel = HomeViewModel(characterService: mockService)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        cancellables = nil
    }
    
    // Test successful fetch of characters
    func testFetchCharactersSuccess() {
        // Given: Mock characters
        mockService.mockCharacters = [
            Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: .init(name: "Earth", url: ""), location: .init(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        ]
        
        // When: Fetch characters
        let expectation = XCTestExpectation(description: "Fetch characters")
        
        viewModel.$characters
            .dropFirst() // Drop the initial empty array
            .sink { characters in
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Rick Sanchez")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCharacters(page: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Test fetch characters failure
    func testFetchCharactersFailure() {
        // Given: Set up the service to return an error
        mockService.error = APIError.invalidResponse
        
        let expectation = XCTestExpectation(description: "Handle error")
        
        viewModel.$errorMessage
            .dropFirst() // Drop the initial nil value
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, APIError.invalidResponse.localizedDescription)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCharacters(page: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Test fetch a single character
    func testFetchSingleCharacterSuccess() {
        // Given: Mock character
        let mockCharacter = Character(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", origin: .init(name: "Earth", url: ""), location: .init(name: "Earth", url: ""), image: "", episode: [], url: "", created: "")
        mockService.mockCharacter = mockCharacter
        
        let expectation = XCTestExpectation(description: "Fetch single character")
        
        viewModel.fetchCharacter(with: 1)
        
        // When: Ensure loading state toggles off
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
