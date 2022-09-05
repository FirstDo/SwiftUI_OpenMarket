//
//  Product.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

struct Product {
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
