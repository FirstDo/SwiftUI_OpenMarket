//
//  NetworkError.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import Foundation

enum NetworkError: LocalizedError {
  case badURL
  case badStatusCode
  case badData
  case badDecoding
  case unknown
  
  var errorDescription: String? {
    switch self {
    case .badURL:
      return "잘못된 URL입니다"
    case .badStatusCode:
      return "잘못된 StatusCode 입니다"
    case .badData:
      return "잘못된 데이터 입니다"
    case .badDecoding:
      return "디코딩에 실패했습니다"
    case .unknown:
      return "알수없는 에러 입니다"
    }
  }
}
