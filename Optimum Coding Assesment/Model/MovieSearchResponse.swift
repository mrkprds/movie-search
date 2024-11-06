//
//  MovieSearchResponse.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation

struct MovieSearchResponse: Decodable {
    let movies: [Movie]
    let response: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case response = "Response"
        case error = "Error"
    }
    
    enum MovieSearchError: Error {
        case invalidResponse(String?)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.response = try container.decode(String.self, forKey: .response)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
        
        // Only decode movies if response is "True"
        if response.lowercased() == "true" {
            self.movies = try container.decode([Movie].self, forKey: .movies)
        } else {
            self.movies = []
            throw MovieSearchError.invalidResponse(error)
        }
    }
}
