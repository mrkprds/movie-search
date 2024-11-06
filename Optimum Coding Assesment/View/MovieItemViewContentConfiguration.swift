//
//  MovieItemContentView.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

struct MovieItemViewContentConfiguration: UIContentConfiguration, Hashable {
    let id: String
    let movieTitle: String
    let releaseYear: String
    let image: String
    
    func makeContentView() -> any UIView & UIContentView {
       return MovieItemContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> MovieItemViewContentConfiguration {
        return self
    }
}

class MovieItemContentView: UIView, UIContentView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var currentConfiguration: MovieItemViewContentConfiguration!
    private var imageLoadingTask: Task<Void, Never>?
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? MovieItemViewContentConfiguration else {
                return
            }
            
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: MovieItemViewContentConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("MovieItemContentView", owner: self, options: nil)
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    private func apply(configuration: MovieItemViewContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        primaryLabel.text = configuration.movieTitle
        secondaryLabel.text = configuration.releaseYear
        
        updateImage(with: URL(string: configuration.image))
        
        currentConfiguration = configuration
    }
    
    private func updateImage(with url: URL?) {
        // Cancel any existing image loading
        imageLoadingTask?.cancel()
        
        // Clear current image and set placeholder
        posterImage.image = UIImage(systemName: "popcorn")
        
        // If no URL, just keep placeholder
        guard let imageURL = url else { return }
        
        // Start new loading task
        imageLoadingTask = Task {
            do {
                let image = try await ImageLoadingService.shared.loadImage(from: imageURL)
                
                // Check if the view is still showing the same content
                guard currentConfiguration?.image == imageURL.absoluteString else { return }
                
                // Animate the image update
                UIView.transition(
                    with: posterImage,
                    duration: 0.3,
                    options: .transitionCrossDissolve
                ) {
                    self.posterImage.image = image
                    self.layoutIfNeeded()
                }
            } catch {
                // Show error placeholder if loading fails
                guard currentConfiguration?.image == imageURL.absoluteString else { return }
                posterImage.image = UIImage(systemName: "exclamationmark.triangle")
            }
        }
    }
}
