//
//  ImageCacheManager.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit

final class ImageCacheManager {
  private let store = NSCache<NSString, UIImage>()
  
  func object(forKey url: URL) -> UIImage? {
    return store.object(forKey: url.absoluteString as NSString)
  }
  
  func setObject(_ object: UIImage, forKey url: URL) {
    store.setObject(object, forKey: url.absoluteString as NSString)
  }
}
