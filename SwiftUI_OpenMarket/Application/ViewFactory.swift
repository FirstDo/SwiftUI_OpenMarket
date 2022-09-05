//
//  ViewFactory.swift
//  SwiftUI_OpenMarket
//
//  Created by 김도연 on 2022/09/06.
//

import SwiftUI

final class ViewFactory: ObservableObject {
  private let container: DIContainer
  
  init(container: DIContainer) {
    self.container = container
  }
  
  func productView(with product: Product) -> ProductView {
    let viewModel = ProductViewModel(product: product, imageDownloader: container.imageDownloder)
    return ProductView(viewModel: viewModel)
  }
}

extension ViewFactory {
  static let preview = ViewFactory(
    container: DIContainer(
      networkService: DefaultNetworkService(),
      imageDownloder: DefaultImageDownloader(cacheManager: ImageCacheManager())
    )
  )
}
