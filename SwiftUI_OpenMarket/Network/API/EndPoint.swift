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
  
  func makeMultiPartFormURLRequest() -> URLRequest? {
    return nil
  }
}

private extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data)
    
    return jsonData as? [String: Any]
  }
}
