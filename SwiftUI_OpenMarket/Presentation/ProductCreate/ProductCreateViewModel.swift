//
//  ProductCreateViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Foundation

final class ProductCreateViewModel: ObservableObject {
  private let productRepository: ProductRepository
  
  init(productRepository: ProductRepository) {
    self.productRepository = productRepository
  }
}
