//
//  NetworkTests.swift
//  SwiftUI_OpenMarketTests
//
//  Created by dudu on 2022/09/05.
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
    configuration.protocolClasses = [MockURLProtocol.self]
    
    return URLSession(configuration: configuration)
  }
  
  private func makeMockProductsData() {
    let data = try! JSONEncoder().encode(ProductResponseDTO.dummy)
    
    MockURLProtocol.requestHandler = { request in
      return (HTTPURLResponse(), data)
    }
  }
  
  private func makeMockProductData() {
    let data = try! JSONEncoder().encode(ProductDTO.dummy)
    
    MockURLProtocol.requestHandler = { request in
      return (HTTPURLResponse(), data)
    }
  }
}
