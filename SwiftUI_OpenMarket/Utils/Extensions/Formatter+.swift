//
//  Formatter+.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Foundation

extension Formatter {
  static let number: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.minimumFractionDigits = 0
    
    return formatter
  }()
}
