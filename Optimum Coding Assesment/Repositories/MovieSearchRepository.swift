//
//  MovieSearchRepository.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation

actor MovieSearchRepository {
    
    private typealias Parameters = URLConstants.Parameters
    private let networkManger: NetworkRequestManager
    private let apiKey: String
    
    init() throws {
        let baseURl: String =  try URLConstants.Config.value(for: .BASE_URL)
        apiKey = try URLConstants.Config.value(for: .API_KEY)
        self.networkManger = NetworkRequestManager(baseURL: baseURl)
    }
    
    func search(for query: String) async throws -> [Movie] {
        let result: MovieSearchResponse = try await networkManger.sendNetworkRequest(
            withParameters: [
                Parameters.search.rawValue: query,
                Parameters.searchType.rawValue: URLConstants.SearchTypes.movie.rawValue,
                Parameters.apikey.rawValue: apiKey
            ],
            httpMethod: .get
        )
        
        return result.movies
    }
}
