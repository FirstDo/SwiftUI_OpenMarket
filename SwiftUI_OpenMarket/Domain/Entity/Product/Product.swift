//
//  Product.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

struct Product: Identifiable {
  let id: Int
  let vendorId: Int
  let name: String
  var description: String?
  let thumbnail: String
  let currency: String
  let price: Double
  let bargainPrice: Double
  let discountedPrice: Double
  let stock: Int
  var images: [ProductImage]?
  var vendor: Vendor?
  let createdAt: String
  let issuedAt: String
}

extension Product {
  static let preview = Product(
    id: 522,
    vendorId: 6,
    name: "아이폰13",
    description: "비싸",
    thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
    currency: "KRW",
    price: 13000,
    bargainPrice: 12000,
    discountedPrice: 1000,
    stock: 10,
    images: nil,
    vendor: nil,
    createdAt: "2022-01-18T00:00:00.00",
    issuedAt: "2022-01-18T00:00:00.00"
  )
  
  func makeRequestDTO() -> ProductRequestDTO {
    return ProductRequestDTO(
      name: self.name,
      description: self.description,
      price: self.price,
      currency: self.currency,
      discountedPrice: self.discountedPrice,
      stock: self.stock,
      vendorSecretKey: UserInformation.password
    )
  }
}
