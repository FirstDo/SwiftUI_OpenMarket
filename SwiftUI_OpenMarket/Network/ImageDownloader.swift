//
//  ImageService.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Combine
import Foundation
import UIKit

protocol ImageDownloader {
  func download(imageURL url: String) async throws -> UIImage
}

final class DefaultImageDownloader: ImageDownloader {
  private let cacheManager: ImageCacheManager
  private let session: URLSession
  
  init(cacheManager: ImageCacheManager, session: URLSession = .shared) {
    self.cacheManager = cacheManager
    self.session = session
  }
  
  func download(imageURL urlString: String) async throws -> UIImage {
    guard let url = URL(string: urlString) else {
      throw NetworkError.BadURL
    }
    
    if let cachedImage = cacheManager.object(forKey: url) {
      return cachedImage
    }
    
    let (data, response) = try await session.data(from: url)
    
    guard let response = (response as? HTTPURLResponse)?.statusCode,
          (200..<300) ~= response else {
      throw NetworkError.BadStatusCode
    }
    
    guard let image = UIImage(data: data) else {
      throw NetworkError.BadData
    }
    
    cacheManager.setObject(image, forKey: url)
    
    return image
  }
}
