//
//  ViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        title = "Search"
        navigationItem.searchController = searchController
    }

}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

