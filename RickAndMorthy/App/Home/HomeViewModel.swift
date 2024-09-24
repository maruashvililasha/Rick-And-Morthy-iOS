//
//  HomeViewModel.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//
import Combine
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    private var currentPage = 1

    private var cancellables = Set<AnyCancellable>()
    private let charactersService: CharactersServiceType
    

    init(characterService: CharactersServiceType = CharactersService()) {
        self.charactersService = characterService
    }

    func fetchCharacters(page: Int?) {
        guard !isLoading else { return }
        isLoading = true
        
        charactersService.getCharacters(page: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                self?.characters.append(contentsOf: response.results)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func getImage(for characterId: Int) -> String? {
        return characters.filter({$0.id == characterId}).first?.image
    }
    
    func fetchCharacter(with id: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        charactersService.getCharacter(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                dump(response)
            })
            .store(in: &cancellables)
    }

    // Fetch the next page when needed
    func fetchNextPageIfNeeded(currentCharacter: Character) {
        if characters.last == currentCharacter {
            fetchCharacters(page: currentPage)
        }
    }
}
