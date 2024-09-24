//
//  Episode.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

struct Episode: Decodable {
    let id: Int
        let name: String
        let airDate: String
        let episode: String
        let characters: [String]
        let url: String
        let created: String

        private enum CodingKeys: String, CodingKey {
          case id
          case name
          case airDate = "air_date"
          case episode
          case characters
          case url
          case created
        }
}
