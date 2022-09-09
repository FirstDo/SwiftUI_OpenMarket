//
//  EndPoint.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

protocol EndPoint {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queryParameters: [String: String]? { get }
  var bodyParameters: Encodable? { get }
  var headers: [String: String] { get}
}

extension EndPoint {
  private func makeURL() -> URL? {
    var urlComponents = URLComponents(string: baseURL + path)
    
    if let queryParameters = queryParameters {
      urlComponents?.queryItems = queryParameters
        .map { key, value in
          URLQueryItem(name: key, value: value)
        }
    }
    
    return urlComponents?.url
  }
  
  func makeURLRequest() -> URLRequest? {
    guard let url = makeURL() else { return nil }
    var request = URLRequest(url: url)
    
    request.httpMethod = method.rawValue
    headers.forEach { key, value in
      request.addValue(value, forHTTPHeaderField: key)
    }
    
    if let bodyParameters = bodyParameters {
      guard let body = try? bodyParameters.toDictionary() else { return nil }
      request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }
    
    return request
  }
  
  func makeMultiPartFormURLRequest(product: Product, imageDatas: [Data]) -> URLRequest? {
    guard let url = makeURL() else { return nil }
    var request = URLRequest(url: url)
    
    request.httpMethod = method.rawValue
    headers.forEach { key, value in
      request.addValue(value, forHTTPHeaderField: key)
    }
    
    request.httpBody = makeMultiPartFormData(product: product, imageDatas: imageDatas)
    return request
  }
  
  private func makeMultiPartFormData(product: Product, imageDatas: [Data]) -> Data! {
    let productData = try! JSONEncoder().encode(product.makeRequestDTO())
    
    var data = Data()
    let boundary = UserInformation.boundary
    
    let newLine = "\r\n"
    let boundaryPrefix = "--\(boundary)\r\n"
    let boundarySuffix = "\r\n--\(boundary)--\r\n"
    
    data.appendString(boundaryPrefix)
    data.appendString("Content-Disposition: form-data; name=\"params\"\r\n")
    data.appendString("Content-Type: application/json\r\n")
    data.appendString("\r\n")
    data.append(productData)
    data.appendString(newLine)
    
    imageDatas.forEach { imageData in
      data.appendString(boundaryPrefix)
      data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(12345).jpg\"\r\n")
      data.appendString("Content-Type: image/jpg\r\n\r\n")
      data.append(imageData)
      data.appendString(newLine)
    }
    data.appendString(boundarySuffix)
    
    return data
  }
}

private extension Data {
  mutating func appendString(_ stringValue: String) {
    if let data = stringValue.data(using: .utf8) {
      self.append(data)
    }
  }
}

private extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data)
    
    return jsonData as? [String: Any]
  }
}
