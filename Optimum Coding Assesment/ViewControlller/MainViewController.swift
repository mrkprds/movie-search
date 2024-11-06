//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchController = UISearchController()
    private var repository: MovieSearchRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Movie Search"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        
        do {
            repository = try MovieSearchRepository()
        } catch {
            print(error)
        }
            
    }

}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        Task {
            do {
                let result = try await repository?.search(for: searchText)
                print(result)
            } catch {
                print(error)
            }
        }
       
    }
}

