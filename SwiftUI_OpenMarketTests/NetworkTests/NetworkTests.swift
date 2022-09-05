//
//  NetworkTests.swift
//  SwiftUI_OpenMarketTests
//
//  Created by 김도연 on 2022/09/05.
//

import XCTest
@testable import SwiftUI_OpenMarket

import Combine

class NetworkTests: XCTestCase {
  
  var sut: NetworkService!
  var cancellables = Set<AnyCancellable>()
  
  override func setUpWithError() throws {
    sut = DefaultNetworkService(session: makeMockURLSession())
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func test_상품리스트가조회되어야한다() {
    // given
    let expectation = XCTestExpectation(description: "상품리스트가조회되어야한다")
    let expectedValue = 10
    var value = 0
    
    let endPoint = RequestProductList(queryParameters: ["page_no": "1", "items_per_page": "10"])
    makeMockProductsData()
    
    // when
    sut.request(endPoint: endPoint)
      .decode(type: ProductResponseDTO.self, decoder: JSONDecoder())
      .print()
      .sink(
        receiveCompletion: { _ in
          
        },
        receiveValue: { items in
          value = items.products.count
          expectation.fulfill()
        }
      )
      .store(in: &cancellables)

    // then
    wait(for: [expectation], timeout: 10.0)
    XCTAssertEqual(expectedValue, value)
  }
  
  func test_상품상세가조회되어야한다() {
    // given
    let expectation = XCTestExpectation(description: "상품상세가조회되어야한다")
    let expectedValue = true
    var value = false
    
    let endPoint = RequestProduct(path: "3541")
    makeMockProductData()
    
    // when
    sut.request(endPoint: endPoint)
      .decode(type: ProductDTO.self, decoder: JSONDecoder())
      .print()
      .sink(receiveCompletion: { _ in
        
      }, receiveValue: { item in
        value = true
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    
    // then
    wait(for: [expectation], timeout: 10.0)
    XCTAssertEqual(expectedValue, value)
  }
}

// MARK: - SetUP Method

private extension NetworkTests {
  private func makeMockURLSession() -> URLSession {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocl.self]
    
    return URLSession(configuration: configuration)
  }
  
  private func makeMockProductsData() {
    let data = try! JSONEncoder().encode(ProductResponseDTO.dummy)
    
    MockURLProtocl.requestHandler = { request in
      return (HTTPURLResponse(), data)
    }
  }
  
  private func makeMockProductData() {
    let data = try! JSONEncoder().encode(ProductDTO.dummy)
    
    MockURLProtocl.requestHandler = { request in
      return (HTTPURLResponse(), data)
    }
  }
}

private extension ProductResponseDTO {
  static let dummy = ProductResponseDTO(
    pageNumber: 2,
    itemsPerPage: 10,
    totalCount: 325,
    offset: 10,
    limit: 20,
    lastPage: 33,
    hasNext: true,
    hasPrev: true,
    products: [
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
      ProductDTO.dummy,
    ]
  )
}

private extension ProductDTO {
  static let dummy = ProductDTO(
    id: 522,
    vendorId: 6,
    name: "아이폰13",
    description: "비싸",
    thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/f9aa6e0d787711ecabfa3f1efeb4842b.jpg",
    currency: "KRW",
    price: 13000,
    bargainPrice: 12000,
    discountedPrice: 1000,
    stock: 10,
    images: nil,
    vendor: nil,
    createdAt: "2022-01-18T00:00:00.00",
    issuedAt: "2022-01-18T00:00:00.00"
  )
}
