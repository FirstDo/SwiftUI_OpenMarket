//
//  FavoriteItemStorage.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/10.
//

protocol FavoriteItemStorage {
  func toggleStar(_ id: Int)
  func getObject(id: Int) -> Bool
}

final class DefaultFavoriteItemStorage: FavoriteItemStorage {
  private var dictionary: [Int: Bool] = [:]
  
  func toggleStar(_ id: Int) {
    let oldValue = dictionary[id] ?? false
    dictionary[id] = oldValue
    dictionary[id]?.toggle()
  }
  
  func getObject(id: Int) -> Bool {
    return dictionary[id] ?? false
  }
}
