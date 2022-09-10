//
//  ProductMainViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Combine
import Foundation

final class ProductMainViewModel: ObservableObject {
  private let productRepository: ProductRepository
  private var cancellables = Set<AnyCancellable>()
  private var page: Int = 1
  
  init(productRepository: ProductRepository) {
    self.productRepository = productRepository
    refresh()
  }
  
  private func requestProducts(page: Int, itemPerPage: Int) {
    productRepository.requestProducts(page: page, itemPerPage: itemPerPage)
      .replaceError(with: [])
      .receive(on: DispatchQueue.main)
      .sink { [weak self] products in
        self?.items.append(contentsOf: products)
      }
      .store(in: &cancellables)
  }
  
  private func resetData() {
    self.page = 1
    self.items = []
  }

  // MARK: - Input
  
  func refresh() {
    resetData()
    request(0)
  }
  
  func productItemDidTap(_ product: Product) {
    selectedProduct = product
    showProductDetailView = true
  }
  
  func addProductButtonDidTap() {
    showRegisterView = true
  }

  func request(_ row: Int) {
    if (row + 10) / 20 + 1 == page {
      requestProducts(page: page, itemPerPage: 20)
      page += 1
    }
  }
  
  // MARK: - OutPut
  
  @Published var items: [Product] = []
  @Published var query = ""
  
  var results: [Product] {
    if query.isEmpty {
      return items
    } else {
      return items.filter { $0.name.contains(query)}
    }
  }

  // MARK: - Routing
  
  @Published var showRegisterView = false
  @Published var showProductDetailView = false
  @Published var selectedProduct = Product.preview
}
