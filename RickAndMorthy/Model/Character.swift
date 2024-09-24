//
//  Character.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

// MARK: - Character
struct Character: Decodable, Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationReference
    let location: LocationReference
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - LocationReference
struct LocationReference: Decodable {
    let name: String
    let url: String
}
