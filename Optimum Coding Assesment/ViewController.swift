//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

struct MovieSearchResponse: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}

// MARK: - Movie Model
struct Movie: Decodable, Identifiable {
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


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Task {
            do {
                let baseURl: String =  try URLConstants.Config.value(for: .BASE_URL)
                let apiKey: String = try URLConstants.Config.value(for: .API_KEY)
                let test = NetworkRequestManager(baseURL: baseURl)
                let params: [String: Any] = ["s": "avatar", "apikey": apiKey]
                let another: MovieSearchResponse = try await test.sendNetworkRequest(withParameters: params, httpMethod: .get)
                print(another.movies)
                
                
            } catch {
                print("error \(error)")
            }
        }
    }

}

