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
        
        currentConfiguration = configuration
    }
}
