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
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(_):
          self?.errorMessage = "물건등록을 실패했습니다"
          self?.showAlertView = true
          break
        }
      } receiveValue: { [weak self] _ in
        // TODO: Success처리
        self?.dismissView = true
      }
      .store(in: &cancellables)
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
  @Published var dismissView: Bool = false
  @Published var showAlertView: Bool = false
  var errorMessage: String = ""
}
