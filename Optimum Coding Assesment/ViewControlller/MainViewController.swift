//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private var viewModel: MovieSearchViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Movie Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        do {
            //Setup Dependencies
            let repository = try MovieSearchRepository()
            let viewModel = MovieSearchViewModel(repository: repository)
            self.viewModel = viewModel
            
            //Setup Search Controller
            let vc = MovieSearchResultsViewController.instantiate(withViewModel: viewModel)
            let searchController = UISearchController(searchResultsController: vc)
            searchController.searchResultsUpdater = self
            navigationItem.searchController = searchController
            
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

