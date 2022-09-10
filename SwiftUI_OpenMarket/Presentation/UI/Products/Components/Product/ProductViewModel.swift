//
//  ProductViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import Combine

final class ProductViewModel: ObservableObject {
  private let product: Product
  private let imageDownloader: ImageDownloader
  private let starStorage: FavoriteItemStorage
  private var cancellabels = Set<AnyCancellable>()
  
  init(product: Product, imageDownloader: ImageDownloader, starStorage: FavoriteItemStorage) {
    self.product = product
    self.imageDownloader = imageDownloader
    self.starStorage = starStorage
    self.isLike = starStorage.getObject(id: product.id)
    
    Task {
      await downloadImage(imageURL: product.thumbnail)
    }
  }
  
  private func downloadImage(imageURL url: String) async {
    do {
      let image = try await imageDownloader.download(imageURL: url)
      
      await MainActor.run {
        self.image = image
        self.isLoading = false
      }
      
    } catch {
      await MainActor.run {
        self.image = .placeholder
        self.isLoading = false
      }
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
  
  // MARK: - Input
  
  func starButtonDidTap() {
    starStorage.toggleStar(product.id)
    isLike = starStorage.getObject(id: product.id)
  }
  
  // MARK: - Output
  
  @Published var isLoading: Bool = true
  @Published var isLike: Bool
  @Published var image: UIImage = UIImage(systemName: "swift")!
  
  var name: String {
    return product.name
  }
  
  var price: String {
    return formattedPrice(number: product.price) + currency
  }
  
  var bargainPrice: String {
    return formattedPrice(number: product.bargainPrice) + currency
  }
  
  var discountPercentage: String {
    guard product.price != 0 else {
      return "0%"
    }
    
    let percentage = product.discountedPrice / product.price * 100

    if (0..<1) ~= percentage {
      return "1%"
    } else {
      return "\(Int(percentage))%"
    }
  }
  
  var stock: String {
    return String(product.stock)
  }
  
  var isSale: Bool {
    return product.discountedPrice != .zero
  }
}
