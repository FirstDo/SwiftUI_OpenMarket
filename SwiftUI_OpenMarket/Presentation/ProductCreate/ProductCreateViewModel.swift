//
//  ProductCreateViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import Combine

final class ProductCreateViewModel: ObservableObject {
  private let productRepository: ProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  init(productRepository: ProductRepository) {
    self.productRepository = productRepository
  }
  
  private var confirmTitle: Bool {
    return !title.isEmpty
  }
  
  private var confirmPrice: Bool {
    guard let numberPrice = Int(price),
          numberPrice >= 0, String(numberPrice) == price else {
      return false
    }
    
    return true
  }
  
  private var confirmDiscountPrice: Bool {
    guard let numberPrice = Int(price) else { return false }
    guard let numberDiscountPrice = Int(discountPrice),
          numberDiscountPrice >= 0 ,
          String(numberDiscountPrice) == discountPrice,
          numberPrice >= numberDiscountPrice else {
      return false
    }
          
    return true
  }
  
  private var confirmStock: Bool {
    guard let numberStock = Int(stock),
          numberStock >= 0,
          String(numberStock) == stock else {
      return false
    }
    
    return true
  }
  
  private var confirmDescription: Bool {
    return !description.isEmpty
  }
  
  private var confirmInputs: Bool {
    return confirmTitle && confirmPrice && confirmDiscountPrice && confirmStock && confirmDescription
  }
  
  // MARK: - Input
  
  func registerButtonDidTap() {
    if confirmInputs {
      productRepository.postProduct(
        product: Product(
          id: 0,
          vendorId: 0,
          name: self.title,
          description: self.description,
          thumbnail: "",
          currency: "KRW",
          price: Double(self.price)!,
          bargainPrice: .zero,
          discountedPrice: Double(self.discountPrice)!,
          stock: Int(self.stock)!,
          createdAt: "",
          issuedAt: ""
        ),
        imageDatas: images.map { $0.jpegData(compressionQuality: 0.1)! }
      )
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          // TODO: Error처리
          break
        }
      } receiveValue: { _ in
        // TODO: Success처리
      }
      .store(in: &cancellables)

      dismissView = true
    } else {
      showAlertView = true
    }
  }
  
  func cameraImageDidTap() {
    showPhotoPickerView = true
  }
  
  func closeButtonDidTap() {
    dismissView = true
  }
  
  // MARK: - Output
  
  @Published var price: String = ""
  @Published var title: String = ""
  @Published var discountPrice: String = ""
  @Published var stock: String = ""
  @Published var description: String = ""
  @Published var images: [UIImage] = []
  
  // MARK: - Routing

  @Published var showPhotoPickerView: Bool = false
  @Published var showAlertView: Bool = false
  @Published var dismissView: Bool = false
}
