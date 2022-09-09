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
  func requestPassword(id: Int, secret: String) -> AnyPublisher<String, NetworkError>
  func postProduct(product: Product, imageDatas: [Data]) -> AnyPublisher<Void, NetworkError>
  func deleteProduct(id: Int, deleteSecret: String) -> AnyPublisher<Void, NetworkError>
}

final class DefaultProductRepository: ProductRepository {
  private let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func requestProduct(id: Int) -> AnyPublisher<Product, NetworkError> {
    let endPoint = RequestProduct(path: "/\(id)")

    return networkService.request(endPoint: endPoint)
      .decode(type: ProductDTO.self, decoder: JSONDecoder())
      .map { $0.toEntity() }
      .mapError { error in
        error as? NetworkError ?? .badDecoding
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
        error as? NetworkError ?? .badDecoding
      }
      .eraseToAnyPublisher()
  }
  
  func requestPassword(id: Int, secret: String) -> AnyPublisher<String, NetworkError> {
    let endPoint = RequestPassword(path: "/\(id)/secret", bodyParameters: ["secret": secret])
    
    return networkService.request(endPoint: endPoint)
      .tryMap { data in
        guard let text = String(data: data, encoding: .utf8) else {
          throw NetworkError.badDecoding
        }
        
        return text
      }
      .mapError { error in
        error as? NetworkError ?? .badDecoding
      }
      .eraseToAnyPublisher()
  }
  
  func postProduct(product: Product, imageDatas: [Data]) -> AnyPublisher<Void, NetworkError> {
    let endPoint = PostProduct()
    return networkService.requestMultiPartForm(endPoint: endPoint, product: product, datas: imageDatas)
      .decode(type: ProductDTO.self, decoder: JSONDecoder())
      .map { _ in }
      .mapError { error in
        error as? NetworkError ?? .badDecoding
      }
      .eraseToAnyPublisher()
  }
  
  func deleteProduct(id: Int, deleteSecret: String) -> AnyPublisher<Void, NetworkError> {
    let endPoint = DeleteProduct(path: "/\(id)/\(deleteSecret)")
    return networkService.request(endPoint: endPoint)
      .map { _ in }
      .eraseToAnyPublisher()
  }
}
