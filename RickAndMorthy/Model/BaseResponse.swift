//
//  BaseResponse.swift
//  RickAndMorthy
//
//  Created by Lasha Maruashvili on 24.09.24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let info: Info
    let results: T
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
