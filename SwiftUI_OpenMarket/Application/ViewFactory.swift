//
//  ViewFactory.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

final class ViewFactory: ObservableObject {
  private let container: DIContainer
  
  init(container: DIContainer) {
    self.container = container
  }
  
  // MARK: - Promotion
  
  func promotionView() -> PromotionView {
    let viewModel = PromotionViewModel(productRepository: container.productRepository)
    return PromotionView(viewModel: viewModel)
  }
  
  func productGridView(with product: Product) -> ProductGridView {
    let viewModel = ProductViewModel(
      product: product, imageDownloader:
        container.imageDownloder,
      starStorage: container.userData.favoriteItemStorage
    )
    return ProductGridView(viewModel: viewModel)
  }
  
  // MARK: ProductMain
  
  func productView(with product: Product) -> ProductView {
    let viewModel = ProductViewModel(
      product: product, imageDownloader:
        container.imageDownloder,
      starStorage: container.userData.favoriteItemStorage
    )
    return ProductView(viewModel: viewModel)
  }
  
  func productMainView() -> ProductMainView {
    let viewModel = ProductMainViewModel(productRepository: container.productRepository)
    return ProductMainView(viewModel: viewModel)
  }
  
  // MARK: ProductDetail
  
  func productDetailView(with product: Product) -> ProductDetailView {
    let viewModel = ProductDetailViewModel(
      product: product,
      imageDownloader: container.imageDownloder,
      productRepository: container.productRepository,
      starStorage: container.userData.favoriteItemStorage
    )
    return ProductDetailView(viewModel: viewModel)
  }
  
  // MARK: ProductCreate
  
  func productCreateView() -> ProductCreateView {
    let viewModel = ProductCreateViewModel(productRepository: container.productRepository)
    return ProductCreateView(viewModel: viewModel)
  }
}

extension ViewFactory {
  static let preview = ViewFactory(
    container: DIContainer(
      productRepository: DefaultProductRepository(networkService: DefaultNetworkService()),
      imageDownloder: DefaultImageDownloader(cacheManager: ImageCacheManager()),
      userData: UserData(favoriteItemStorage: DefaultFavoriteItemStorage())
    )
  )
}
