//
//  ImageLoadingService.swift
//  Optimum Coding Assesment
//
//  Created by Patrick Perdon on 06/11/2024.
//

import UIKit

/// Object responsible for loading and caching of an image
actor ImageLoadingService {
    
    static let shared = ImageLoadingService()
    private var cache = NSCache<NSURL, UIImage>()
    
    enum ImageError: Error {
        case invalidData
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        // Check cache first
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        // Load from network
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }
        
        // Cache the image
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
