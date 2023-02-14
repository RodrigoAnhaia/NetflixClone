//
//  Movie.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 21/01/23.
//

import Foundation


struct TitleResponse: Codable {
    let results: [Title]
    
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let title: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let vote_count: Int
    let vote_average: Double?
    let genre_ids: [Int]
    
}
