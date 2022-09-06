//
//  ProductCreateViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit

final class ProductCreateViewModel: ObservableObject {
  private let productRepository: ProductRepository
  
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
      // TODO: register Product
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
