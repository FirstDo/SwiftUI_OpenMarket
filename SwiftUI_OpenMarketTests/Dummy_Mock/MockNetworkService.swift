//
//  MockNetworkService.swift
//  SwiftUI_OpenMarketTests
//
//  Created by dudu on 2022/09/05.
//

import Foundation
import Combine

@testable import SwiftUI_OpenMarket

struct MockNetworkService: NetworkService {
  static var items: Data!
  
  func request(endPoint: EndPoint) -> AnyPublisher<Data, NetworkError> {
    return Just(Self.items)
      .mapError { _ in NetworkError.BadURL }
      .eraseToAnyPublisher()
  }
  
  func requestMultiPartForm(endPoint: EndPoint) -> AnyPublisher<Data, NetworkError> {
    return Just(Self.items)
      .mapError { _ in NetworkError.BadURL }
      .eraseToAnyPublisher()
  }
}
