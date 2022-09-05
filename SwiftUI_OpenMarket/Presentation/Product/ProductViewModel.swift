//
//  ProductViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Foundation

final class ProductViewModel: ObservableObject {
  private let product: Product
  
  init(product: Product) {
    self.product = product
  }
  
  private var currency: String {
    if product.currency == "KRW" {
      return "원"
    } else {
      return "달러"
    }
  }
  
  private func formattedPrice(number: Double) -> String {
    return Formatter.number.string(for: number) ?? "0"
  }
  
  // MARK: - Output
  
  var name: String {
    return product.name
  }
  
  var imageURL: String {
    return product.thumbnail
  }
  
  var price: String {
    return formattedPrice(number: product.price) + currency
  }
  
  var bargainPrice: String {
    return formattedPrice(number: product.bargainPrice) + currency
  }
  
  var discountPercentage: String {
    let percentage = product.discountedPrice / product.price * 100
    
    return "\(Int(percentage))%"
  }
  
  var stock: String {
    return String(product.stock)
  }
  
  var isSale: Bool {
    return product.discountedPrice != .zero
  }
  
  var isLike: Bool {
    return true
  }
}
