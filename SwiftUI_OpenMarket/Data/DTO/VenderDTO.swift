//
//  VenderDTO.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

struct VendorDTO: Codable {
  let id: Int
  let name: String
  let createdAt: String
  let issuedAt: String

  private enum CodingKeys: String, CodingKey {
    case id, name
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
