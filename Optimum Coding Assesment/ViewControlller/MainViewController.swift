//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchController = UISearchController()
    private var viewModel: MovieSearchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Movie Search"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        
        do {
            let repository = try MovieSearchRepository()
            viewModel = MovieSearchViewModel(repository: repository)
        } catch {
            
            let alert = UIAlertController(
                title: "Error",
                message: "An error occurred on loading movie search repository",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        viewModel?.searchQuery = searchText
    }
}

