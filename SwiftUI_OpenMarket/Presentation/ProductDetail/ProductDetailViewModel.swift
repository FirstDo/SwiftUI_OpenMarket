//
//  ProductDetailViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import Combine

final class ProductDetailViewModel: ObservableObject {
  @Published private var product: Product
  private let imageDownloader: ImageDownloader
  private let productRepository: ProductRepository
  
  private var cancellable = Set<AnyCancellable>()
  
  init(product: Product, imageDownloader: ImageDownloader, productRepository: ProductRepository) {
    self.imageDownloader = imageDownloader
    self.productRepository = productRepository
    self.product = product
  }
  
  private func downloadImage(imageURL urls: [String]) async {
    let images = await withTaskGroup(of: UIImage.self) { group -> [UIImage] in
      var images = [UIImage]()
      images.reserveCapacity(urls.count)
      
      for url in urls {
        group.addTask {
          guard let image = try? await self.imageDownloader.download(imageURL: url) else {
            return UIImage(systemName: "swift")!
          }
          
          return image
        }
      }
      
      for await image in group {
        images.append(image)
      }
      
      return images
    }
    
    await MainActor.run {
      self.images = images
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
  
  func requestProduct() {
    productRepository.requestProduct(id: product.id)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        
      } receiveValue: { [weak self] product in
        guard let self = self else { return }
        
        self.product = product
        guard let images = product.images else { return }
        
        Task {
          await self.downloadImage(imageURL: images.map { $0.url })
        }
      }
      .store(in: &cancellable)
  }
  
  // MARK: - Output
  
  var name: String {
    return product.name
  }
  
  var description: String {
    return product.description ?? ""
  }
  
  @Published var images: [UIImage] = [UIImage(systemName: "swift")!]
  
  var venderName: String {
    return product.vendor?.name ?? "익명"
  }
  
  var price: String {
    return formattedPrice(number: product.price) + currency
  }
  
  var bargainPrice: String {
    return formattedPrice(number: product.bargainPrice) + currency
  }
  
  var stock: String {
    return "\(product.stock)개 남음"
  }
  
  var isSale: Bool {
    return product.discountedPrice != .zero
  }
  
  var isLike: Bool {
    return true
  }
}
