//
//  ProductDetailViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import Combine

typealias AlertComponent = (title: String, message: String?)

final class ProductDetailViewModel: ObservableObject {
  @Published private var product: Product
  private let imageDownloader: ImageDownloader
  private let productRepository: ProductRepository
  private let starStorage: FavoriteItemStorage
  private let updateTrigger: () -> Void
  
  private var cancellables = Set<AnyCancellable>()
  
  init(
    product: Product,
    imageDownloader: ImageDownloader,
    productRepository: ProductRepository,
    starStorage: FavoriteItemStorage,
    updateTrigger: @escaping () -> Void
  ) {
    self.product = product
    self.imageDownloader = imageDownloader
    self.productRepository = productRepository
    self.starStorage = starStorage
    self.updateTrigger = updateTrigger
    self.isLike = starStorage.getObject(id: product.id)
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
  
  private func deleteProductRequest(password: String) {
    productRepository.deleteProduct(id: self.product.id, deleteSecret: password)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] compeltion in
        // MARK: TODO - ShowErrorAlert
        switch compeltion {
        case .finished:
          break
        case .failure(let error):
          self?.setAlertComponent(title: "네트워크 에러", message: error.localizedDescription)
        }
      } receiveValue: { [weak self] _ in
        self?.setAlertComponent(title: "삭제 완료", message: "마켓에서 물건이 삭제되었어요 :)")
      }
      .store(in: &cancellables)
  }
  
  private func setAlertComponent(title: String, message: String) {
    alert.title = title
    alert.message = message
    showAlert = true
  }
  
  // MARK: - Input
  
  func deleteButtonDidTap() {
    productRepository.requestPassword(id: self.product.id, secret: UserInformation.password)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.setAlertComponent(title: "네트워크 에러", message: error.localizedDescription)
        }
      } receiveValue: { [weak self] text in
        self?.deleteProductRequest(password: text)
      }
      .store(in: &cancellables)
  }
  
  func deleteSuccessButtonDidTap() {
    self.dismissView = true
    self.updateTrigger()
  }
  
  func editButtonDidTap() {
    
  }
  
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
      .store(in: &cancellables)
  }
  
  func starImageDidTap() {
    starStorage.toggleStar(product.id)
    isLike = starStorage.getObject(id: product.id)
  }
  
  // MARK: - Output
  
  @Published var isLike: Bool
  @Published var images: [UIImage] = [UIImage(systemName: "swift")!]
  
  var isOwner: Bool {
    return product.vendorId == UserInformation.id
  }
  
  var name: String {
    return product.name
  }
  
  var description: String {
    return product.description ?? ""
  }
  
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
  
  // MARK: - Routing
  
  @Published var showAlert: Bool = false
  @Published var dismissView: Bool = false
  var alert: AlertComponent = (title: "", message: "")
}
