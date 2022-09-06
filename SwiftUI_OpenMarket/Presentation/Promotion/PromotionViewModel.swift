//
//  PromotionViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit

import Combine

final class PromotionViewModel: ObservableObject {
  let promotions: [Promotion]
  @Published var products: [Product] = []
  private let productRepository: ProductRepository
  
  private var cancellables = Set<AnyCancellable>()
  
  init(_ promotions: [Promotion] = Promotion.defaultPromotion, productRepository: ProductRepository) {
    self.promotions = promotions
    self.productRepository = productRepository
  }
  
  // MARK: - Input
  
  func openURL(to urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    UIApplication.shared.open(url)
  }
  
  func requestProduct(_ number: Int) {
    productRepository.requestProducts(page: 1, itemPerPage: number)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        
      } receiveValue: { [weak self] products in
        self?.products = products
      }
      .store(in: &cancellables)
  }
  
  // MARK: - Output
  
  @Published var isActive: Bool = false
  @Published var selectedProduct: Product = Product.preview
}
