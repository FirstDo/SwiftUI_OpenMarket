//
//  NetworkError.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

enum NetworkError: LocalizedError {
  case BadURL
  case BadStatusCode
  case BadData
  
  var errorDescription: String? {
    switch self {
    case .BadURL:
      return "잘못된 URL입니다"
    case .BadStatusCode:
      return "잘못된 StatusCode 입니다"
    case .BadData:
      return "잘못된 데이터 입니다"
    }
  }
}
