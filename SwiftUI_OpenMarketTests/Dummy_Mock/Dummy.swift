//
//  Dummy.swift
//  SwiftUI_OpenMarketTests
//
//  Created by dudu on 2022/09/05.
//

import Foundation
@testable import SwiftUI_OpenMarket

extension ProductResponseDTO {
  static let dummy = ProductResponseDTO(
    pageNumber: 2,
    itemsPerPage: 10,
    totalCount: 325,
    offset: 10,
    limit: 20,
    lastPage: 33,
    hasNext: true,
    hasPrev: true,
    products: [
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
    ]
  )
}

extension ProductDTO {
  static let dummy = ProductDTO(
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
}
