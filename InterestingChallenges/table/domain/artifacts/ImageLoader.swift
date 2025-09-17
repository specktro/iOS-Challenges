//
//  ImageLoader.swift
//  InterestingChallenges
//
//  Created by specktro on 16/09/25.
//

import UIKit

// Basic Image Loader (Async + Cancellation)
final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}
    
    // Basic async loading function with cancellation
    @discardableResult
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Always dispatch UI updates to main queue
            DispatchQueue.main.async {
                if let error = error {
                    // Check if it was cancelled
                    if (error as NSError).code == NSURLErrorCancelled {
                        // Don't call completion for cancelled requests
                        return
                    }
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(.failure(ImageLoaderError.invalidData))
                    return
                }
                
                completion(.success(image))
            }
        }
        
        task.resume()
        return task
    }
}

enum ImageLoaderError: Error {
    case invalidData
    case cacheError
}

// Add Memory Cache
extension ImageLoader {
    private static let cache = NSCache<NSString, UIImage>()
    
    // Check cache first, then network
    @discardableResult
    func loadImageWithCache(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        let cacheKey = url.absoluteString as NSString
        
        // Cache hit - return immediately
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            completion(.success(cachedImage))
            // No network task needed
            return nil
        }
        
        // Cache miss - load from network and cache result
        return loadImage(from: url) { result in
            switch result {
            case .success(let image):
                // Cache the image for future use
                Self.cache.setObject(image, forKey: cacheKey)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Enhanced Image Loader with Disk Cache
class AdvancedImageLoader {
    static let shared = AdvancedImageLoader()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheURL: URL
    private let session: URLSession
    
    private init() {
        // Setup disk cache directory
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cacheDir.appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        
        // Configure URLSession for better performance
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024, // 50MB memory
                                   diskCapacity: 200 * 1024 * 1024,   // 200MB disk
                                   diskPath: "URLCache")
        session = URLSession(configuration: config)
        
        // Configure memory cache
        memoryCache.countLimit = 100 // Max 100 images in memory
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB memory limit
    }
    
    @discardableResult
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask? {
        let cacheKey = url.absoluteString as NSString
        
        // Check memory cache first (fastest)
        if let memoryImage = memoryCache.object(forKey: cacheKey) {
            completion(.success(memoryImage))
            return nil
        }
        
        // Check disk cache (fast)
        let diskCacheFile = diskCacheURL.appendingPathComponent(url.lastPathComponent)
        if let diskData = try? Data(contentsOf: diskCacheFile),
           let diskImage = UIImage(data: diskData) {
            // Move to memory cache for faster access
            memoryCache.setObject(diskImage, forKey: cacheKey)
            completion(.success(diskImage))
            return nil
        }
        
        // Load from network (slow)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        return
                    }
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(.failure(ImageLoaderError.invalidData))
                    return
                }
                
                // Cache in both memory and disk
                self.memoryCache.setObject(image, forKey: cacheKey)
                try? data.write(to: diskCacheFile)
                
                completion(.success(image))
            }
        }
        
        task.resume()
        return task
    }
}

// Memory Management and Cleanup
extension AdvancedImageLoader {
    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    func clearDiskCache() {
        try? FileManager.default.removeItem(at: diskCacheURL)
        try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    func handleMemoryWarning() {
        // Clear memory cache on memory pressure
        clearMemoryCache()
    }
}

// Performance Monitoring (Advanced)
class ImageLoadingMetrics {
    static let shared = ImageLoadingMetrics()
    
    private var cacheHits = 0
    private var cacheMisses = 0
    private var loadingTimes: [TimeInterval] = []
    
    func recordCacheHit() {
        cacheHits += 1
    }
    
    func recordCacheMiss() {
        cacheMisses += 1
    }
    
    func recordLoadingTime(_ time: TimeInterval) {
        loadingTimes.append(time)
    }
    
    var cacheHitRatio: Double {
        let total = cacheHits + cacheMisses
        return total > 0 ? Double(cacheHits) / Double(total) : 0
    }
    
    var averageLoadingTime: TimeInterval {
        return loadingTimes.isEmpty ? 0 : loadingTimes.reduce(0, +) / Double(loadingTimes.count)
    }
    
    func printStats() {
        print("Cache Hit Ratio: \(cacheHitRatio * 100)%")
        print("Average Loading Time: \(averageLoadingTime)s")
    }
}
