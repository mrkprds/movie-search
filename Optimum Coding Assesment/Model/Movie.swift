//
//  Movie.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation

struct Movie: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let year: String
    let type: String
    let posterURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case posterURL = "Poster"
    }
}
