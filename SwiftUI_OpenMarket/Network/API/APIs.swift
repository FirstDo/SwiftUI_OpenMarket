//
//  APIs.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

enum UserInformation {
  static let id = 79
  static let identifier = "680a5dc5-d1b8-11ec-9676-819f7cbd69a2"
  static let password = "dxx7xmmtfz"
  static let boundary = UUID().uuidString
}

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

struct PostProduct: EndPoint {
  let baseURL: String = "https://market-training.yagom-academy.kr/api/products"
  let path: String = ""
  let method: HTTPMethod = .post
  let queryParameters: [String : String]? = nil
  let bodyParameters: Encodable? = nil
  let headers: [String : String] = [
      "Content-Type": "multipart/form-data; boundary=\(UserInformation.boundary)",
      "identifier": UserInformation.identifier
  ]
}

struct RequestPassword: EndPoint {
  let baseURL: String = "https://market-training.yagom-academy.kr/api/products"
  let path: String
  let method: HTTPMethod = .post
  let queryParameters: [String : String]? = nil
  let bodyParameters: Encodable?
  let headers: [String : String] = [
      "Content-Type": "application/json",
      "identifier": UserInformation.identifier
  ]
}

struct DeleteProduct: EndPoint {
  let baseURL: String = "https://market-training.yagom-academy.kr/api/products"
  let path: String
  let method: HTTPMethod = .delete
  let queryParameters: [String : String]? = nil
  let bodyParameters: Encodable? = nil
  let headers: [String : String] = [
      "Content-Type": "application/json",
      "identifier": UserInformation.identifier
  ]
}
