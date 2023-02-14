//
//  Genre.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 09/02/23.
//

import Foundation

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Equatable {
    let id: Int?
    let name: String?
}
