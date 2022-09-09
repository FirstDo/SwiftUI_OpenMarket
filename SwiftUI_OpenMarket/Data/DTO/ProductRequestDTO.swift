//
//  ProductRequest.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/09.
//

import Foundation

struct ProductRequestDTO: Encodable {
  var name: String?
  var description: String?
  var price: Double?
  var currency: String?
  var discountedPrice: Double?
  var stock: Int?
  var vendorSecretKey: String?

  private enum CodingKeys: String, CodingKey {
    case name, price, currency, stock
    case description = "descriptions"
    case discountedPrice = "discounted_price"
    case vendorSecretKey = "secret"
  }
}


