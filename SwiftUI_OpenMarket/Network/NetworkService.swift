//
//  NetworkService.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Combine
import Foundation

protocol NetworkService {
  func request(endPoint: EndPoint) -> AnyPublisher<Data, NetworkError>
  func requestMultiPartForm(endPoint: EndPoint, product: Product, datas: [Data]) -> AnyPublisher<Data, NetworkError>
}

struct DefaultNetworkService: NetworkService {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
  
  func request(endPoint: EndPoint) -> AnyPublisher<Data, NetworkError> {
    guard let request = endPoint.makeURLRequest() else {
      return Fail(error: NetworkError.BadURL)
        .eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .mapError { _ in NetworkError.BadStatusCode }
      .eraseToAnyPublisher()
  }
  
  func requestMultiPartForm(endPoint: EndPoint, product: Product, datas: [Data]) -> AnyPublisher<Data, NetworkError> {
    guard let request = endPoint.makeMultiPartFormURLRequest(product: product, imageDatas: datas) else {
      return Fail(error: NetworkError.BadURL)
        .eraseToAnyPublisher()
    }
    
    return session.dataTaskPublisher(for: request)
      .map(\.data)
      .mapError { _ in NetworkError.BadStatusCode }
      .eraseToAnyPublisher()
  }
}
