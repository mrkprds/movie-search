//
//  MovieSearchViewModel.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import Foundation
import Combine

@MainActor
final class MovieSearchViewModel {
    
    @Published private(set) var state: ViewState = .idle
    @Published var searchQuery: String = ""
    
    private var searchObserver: AnyCancellable?
    
    private var searchTask: Task<Void, Never>?
    private let debounceDuration = 0.5
    
    let repository: MovieSearchRepository
    
    enum ViewState {
        case idle
        case loading
        case noResults(query: String)
        case loaded(movies: [Movie])
        case error(Error)
    }
    
    init(repository: MovieSearchRepository) {
        self.repository = repository
        beginObservations()
    }
    
    func beginObservations() {
        searchObserver = $searchQuery
            .debounce(for: .seconds(debounceDuration), scheduler: DispatchQueue.main)
            .sink { [weak self] searchQuery in
                print(searchQuery)
                
                self?.state = .loading
                
                if let searchTask = self?.searchTask {
                    searchTask.cancel()
                }
                
                // Create new task and store it
                self?.searchTask = Task { @MainActor in
                    await self?.performSearch(searchQuery)
                }
            }
    }
    
    private func performSearch(_ query: String) async {
        guard !query.isEmpty else {
            state = .idle
            return
        }
        
        state = .loading
        
        do {
            let result = try await repository.search(for: query)
            
            if result.isEmpty {
                state = .noResults(query: query)
            } else {
                state = .loaded(movies: result)
            }
        } catch {
            state = .error(error)
        }
    }
    
}
