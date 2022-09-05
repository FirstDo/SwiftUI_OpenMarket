//
//  ProductMainView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import SwiftUI

struct ProductMainView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

struct ProductMainView_Previews: PreviewProvider {
  static var previews: some View {
    ProductMainView()
      .environmentObject(ViewFactory.preview)
  }
}
