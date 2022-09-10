//
//  PromotionViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit

import Combine

final class PromotionViewModel: ObservableObject {
  private let productRepository: ProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  init(_ promotions: [Promotion] = Promotion.defaultPromotion, productRepository: ProductRepository) {
    self.promotions = promotions
    self.productRepository = productRepository
    
    requestProduct()
  }
  
  // MARK: - Input
  
  func productItemDidTap(_ product: Product) {
    selectedProduct = product
    showProductDetailView = true
  }
  
  func openURL(to urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    UIApplication.shared.open(url)
  }
  
  func requestProduct() {
    productRepository.requestProducts(page: 1, itemPerPage: 20)
      .replaceError(with: [])
      .receive(on: DispatchQueue.main)
      .sink{ [weak self] products in
        self?.products = products
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Output
  
  let promotions: [Promotion]
  @Published var products: [Product] = []
  
  // MARK: - Routing
  
  @Published var showProductDetailView = false
  @Published var selectedProduct = Product.preview
}
