//
//  ImageModifier.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/10.
//

import SwiftUI

protocol ImageModifier {
  associatedtype Body: View
  
  func body(image: Image) -> Self.Body
}

struct CellImageModifier: ImageModifier {
  let size: CGFloat
  let cornerRadius: CGFloat
  
  func body(image: Image) -> some View {
    image
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .frame(width: size, height: size)
      .cornerRadius(cornerRadius)
  }
}

extension Image {
  func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
    modifier.body(image: self)
  }
  
  func cellStyle(size: CGFloat, radius: CGFloat = 20) -> some View {
    modifier(CellImageModifier(size: size, cornerRadius: radius))
  }
}
