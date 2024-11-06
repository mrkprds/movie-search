//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

