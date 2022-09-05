//
//  ProductImageDTO.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

struct ProductImageDTO: Codable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let succeed: Bool
  let issuedAt: String

  private enum CodingKeys: String, CodingKey {
    case id, url, succeed
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

extension ProductImageDTO {
  func toEntity() -> ProductImage {
    return ProductImage(
      id: id,
      url: url,
      thumbnailURL: thumbnailURL,
      succeed: succeed,
      issuedAt: issuedAt
    )
  }
}
