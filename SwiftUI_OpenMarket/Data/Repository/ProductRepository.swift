//
//  ProductRepository.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Combine
import Foundation

protocol ProductRepository {
  func requestProduct(id: Int) -> AnyPublisher<Product, NetworkError>
  func requestProducts(page: Int, itemPerPage: Int) -> AnyPublisher<[Product], NetworkError>
}

final class DefaultProductRepository: ProductRepository {
  private let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func requestProduct(id: Int) -> AnyPublisher<Product, NetworkError> {
    let endPoint = RequestProduct(path: "\(id)")
    
    return networkService.request(endPoint: endPoint)
      .decode(type: ProductDTO.self, decoder: JSONDecoder())
      .map { $0.toEntity() }
      .mapError { error in
        guard let error = error as? NetworkError else {
          return NetworkError.BadData
        }
        
        return error
      }
      .eraseToAnyPublisher()
  }
  
  func requestProducts(page: Int, itemPerPage: Int) -> AnyPublisher<[Product], NetworkError> {
    let endPoint = RequestProductList(queryParameters: ["page_no": "\(page)", "itmes_per_page": "\(itemPerPage)"])
    
    return networkService.request(endPoint: endPoint)
      .decode(type: ProductResponseDTO.self, decoder: JSONDecoder())
      .map(\.products)
      .map { DTOs in
        DTOs.map { $0.toEntity() }
      }
      .mapError { error in
        guard let error = error as? NetworkError else {
          return NetworkError.BadData
        }
        
        return error
      }
      .eraseToAnyPublisher()
  }
}
