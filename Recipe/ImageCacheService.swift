//
//  ImageCacheService.swift
//  Recipe
//
//  Created by Shivani Gupta on 10/17/24.
//

import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private var cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    init() {
        // Set up the cache directory in the user's caches folder
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("ImageCache")
        
        // Create the directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }

    func loadImage(from url: URL) async -> UIImage? {
        let cacheKey = url.absoluteString as NSString

        // Check the in-memory cache first
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }

        // Check the disk cache
        let cacheFilePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)
        if let image = UIImage(contentsOfFile: cacheFilePath.path) {
            cache.setObject(image, forKey: cacheKey)
            return image
        }

        // Fetch from network
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: cacheKey)
                
                // Save to disk cache
                try data.write(to: cacheFilePath)
                return image
            }
        } catch {
            print("Error loading image: \(error)")
        }

        return nil
    }
}
