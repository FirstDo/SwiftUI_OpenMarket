//
//  ProductRepositoryTests.swift
//  SwiftUI_OpenMarketTests
//
//  Created by 김도연 on 2022/09/05.
//

import XCTest
@testable import SwiftUI_OpenMarket

import Combine

class ProductRepositoryTests: XCTestCase {
  
  var sut: ProductRepository!
  var mockNetworkService: MockNetworkService!
  
  override func setUpWithError() throws {
    mockNetworkService = MockNetworkService()
    sut = DefaultProductRepository(networkService: mockNetworkService)
  }
  
  override func tearDownWithError() throws {
    mockNetworkService = nil
    sut = nil
  }
  
  func test_상품리스트가조회되어야한다() {
    // given
    let expectation = XCTestExpectation(description: "상품리스트가조회되어야한다")
    let expectedValue = 10
    var value = 0
    
    MockNetworkService.items = try! JSONEncoder().encode(ProductResponseDTO.dummy)
    
    
    // when
    _ = sut.requestProducts(page: 1, itemPerPage: 10)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { items in
          value = items.count
          expectation.fulfill()
        }
      )
  
    // then
    wait(for: [expectation], timeout: 10.0)
    XCTAssertEqual(expectedValue, value)
  }
  
  func test_상품상세정보가조회되어야한다() {
    // given
    let expectation = XCTestExpectation(description: "상품상세정보가조회되어야한다")
    let expectedValue = ProductDTO.dummy.thumbnail
    var value = ""
    
    MockNetworkService.items = try! JSONEncoder().encode(ProductDTO.dummy)
    
    // when
    _ = sut.requestProduct(id: 3451)
      .print()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { item in
          value = item.thumbnail
          expectation.fulfill()
        }
      )
    
    // then
    wait(for: [expectation], timeout: 10.0)
    XCTAssertEqual(expectedValue, value)
  }
}
