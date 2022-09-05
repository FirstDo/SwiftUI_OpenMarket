//
//  SwiftUI_OpenMarketApp.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import SwiftUI

@main
struct SwiftUI_OpenMarketApp: App {
  
  private let viewFactory = ViewFactory(
    container: DIContainer(
      productRepository: DefaultProductRepository(networkService: DefaultNetworkService()),
      imageDownloder: DefaultImageDownloader(cacheManager: ImageCacheManager())
    )
  )
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        viewFactory.productMainView()
      }
      .environmentObject(viewFactory)
    }
  }
}
