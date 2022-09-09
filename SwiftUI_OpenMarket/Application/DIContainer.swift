//
//  DIContainer.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import Combine

struct DIContainer {
  let productRepository: ProductRepository
  let imageDownloder: ImageDownloader
  let userData: UserData
}

struct UserData {
  let favoriteItemStorage: FavoriteItemStorage
}
