//
//  ProductRegisterViewModel.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import Combine

final class ProductRegisterViewModel: ObservableObject {
  private let productRepository: ProductRepository
  private let updateTrigger: () -> Void
  private var cancellables = Set<AnyCancellable>()
  
  init(productRepository: ProductRepository, updateTrigger: @escaping () -> Void) {
    self.productRepository = productRepository
    self.updateTrigger = updateTrigger
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
  
  private func setAlertComponent(title: String, message: String?) {
    self.alert.title = title
    self.alert.message = message
    self.showAlert = true
  }
  
  // MARK: - Input
  
  func registerButtonDidTap() {
    if confirmInputs {
      productRepository.postProduct(
        product: Product(
          id: .zero,
          vendorId: .zero,
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
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.setAlertComponent(title: "네트워크 에러", message: error.localizedDescription)
        }
      } receiveValue: { [weak self] _ in
        self?.setAlertComponent(title: "등록 성공", message: "물건이 마켓에 등록되었어요 :)")
      }
      .store(in: &cancellables)
    } else {
      self.setAlertComponent(title: "입력 에러", message: "잘못된 형식이 있습니다 :(")
    }
  }
  
  func alertOKButtonDidTap() {
    if alert.title == "등록 성공" {
      self.updateTrigger()
      self.dismissView = true
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
  @Published var showAlert: Bool = false

  var alert: AlertComponent = (title: "", message: "")
}
