//
//  APIs.swift
//  SwiftUI_OpenMarket
//
//  Created by 김도연 on 2022/09/05.
//

import Foundation

struct RequestProductList: EndPoint {
  let baseURL: String = "https://market-training.yagom-academy.kr/api/products"
  let path: String = ""
  let method: HTTPMethod = .get
  let queryParameters: [String : String]?
  let bodyParameters: Encodable? = nil
  let headers: [String : String] = ["Content-Type": "application/json"]
}

struct RequestProduct: EndPoint {
  let baseURL: String = "https://market-training.yagom-academy.kr/api/products"
  let path: String
  let method: HTTPMethod = .get
  let queryParameters: [String : String]? = nil
  let bodyParameters: Encodable? = nil
  let headers: [String : String] = ["Content-Type": "application/json"]
}
