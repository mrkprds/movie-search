//
//  MovieSearchResultsViewController.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit
import Combine

class MovieSearchResultsViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
    private let viewModel: MovieSearchViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    private var stateObserver: AnyCancellable?
    
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
    
    //MARK: - Setup
    
    override func viewDidLoad() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView.collectionViewLayout = listLayout
        
        beginObservations()
    }
    
    private func configureDataSource() {
        let rowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Movie> { (cell, indexPath, item) in
            var configuration = UIListContentConfiguration.cell()
            configuration.text = item.title
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: rowRegistration, for: indexPath, item: item)
        })
    }
    
    private func beginObservations() {
        stateObserver = viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                   break
                    
                case .loading:
                    var config = UIContentUnavailableConfiguration.loading()
                    config.text = "Loading Movies..."
                    self?.contentUnavailableConfiguration = config
                    
                case .noResults(let searchQuery):
                    var config = UIContentUnavailableConfiguration.empty()
                    config.image = UIImage(systemName: "magnifyingglass")
                    config.text = "No Result"
                    config.secondaryText = "No result found for: \(searchQuery)"
                    self?.contentUnavailableConfiguration = config
                    
                case .error(let error):
                    var config = UIContentUnavailableConfiguration.empty()
                    config.image = UIImage(systemName: "exclamationmark.triangle")
                    config.text = "Error"
                    config.secondaryText = "An error had occurred during the search:\n\(String(describing: error))"
                    self?.contentUnavailableConfiguration = config
                    
                case .loaded(let movies):
                    print(movies)
                }
            }
    }
}
