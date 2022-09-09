//
//  ProductViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit

final class ProductViewModel: ObservableObject {
  private let product: Product
  private let imageDownloader: ImageDownloader
  
  init(product: Product, imageDownloader: ImageDownloader) {
    self.product = product
    self.imageDownloader = imageDownloader
    
    Task {
      await downloadImage(imageURL: product.thumbnail)
    }
  }
  
  private func downloadImage(imageURL url: String) async {
    guard let image = try? await imageDownloader.download(imageURL: url) else { return }
    
    await MainActor.run {
      self.image = image
      self.isLoading = false
    }
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
  
  @Published var isLoading: Bool = true
  var name: String {
    return product.name
  }
  
  @Published var image: UIImage = UIImage(systemName: "swift")!
  
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
