//
//  MovieSearchResponse.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation

struct MovieSearchResponse: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
