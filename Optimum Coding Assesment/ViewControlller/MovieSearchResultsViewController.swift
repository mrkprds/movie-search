//
//  MovieSearchResultsViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

class MovieSearchResultsViewController: UICollectionViewController {
    
    private let viewModel: MovieSearchViewModel
    
    //MARK: - Init
    init?(coder: NSCoder, viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instantiate(withViewModel viewModel: MovieSearchViewModel) -> MovieSearchResultsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: Self.self)) { coder -> MovieSearchResultsViewController? in
            return MovieSearchResultsViewController(coder: coder, viewModel: viewModel)
        }
    }
}
