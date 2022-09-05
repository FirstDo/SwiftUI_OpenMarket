//
//  Promotion.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Foundation

struct Promotion {
  let name: String
  let url: String
}

extension Promotion {
  static let defaultPromotion: [Promotion] = [
    Promotion(
      name: "YagomAcademy",
      url: "https://www.yagom-academy.kr/"
    ),
    Promotion(
      name: "OpenEvent",
      url: ""
    ),
    Promotion(
      name: "Covid19",
      url: "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=%EC%BD%94%EB%A1%9C%EB%82%98+19%ED%98%84%ED%99%A9"
    ),
  ]
}
