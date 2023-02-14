//
//  Cast.swift
//  NetflixClone
//
//  Created by Rodrigo Sanseverino de Anhaia on 13/02/23.
//

import Foundation

struct Credits: Codable {
    let id: Int
    let cast: [Actors]?
    let crew: [Employees]?
}

struct Actors:  Codable {
    var gender: Int?
    var id: Int
    var known_for_department: String?
    var name: String?
    var original_name: String?
    var popularity: Double?
    var profile_path: String?
    var credit_id: String?
    let cast_id: Int
    let character: String?
    let order: Int?
}


struct Employees:  Codable {
    var gender: Int?
    var id: Int
    var known_for_department: String?
    var name: String?
    var original_name: String?
    var popularity: Double?
    var profile_path: String?
    var credit_id: String?
    let department: String?
    let job: String?
}

protocol BasePerson: Codable {
    var gender: Int? { get }
    var id: Int { get }
    var known_for_department: String? { get }
    var name: String? { get }
    var original_name: String? { get }
    var popularity: Double? { get }
    var profile_path: String? { get }
    var credit_id: String? { get }
}
