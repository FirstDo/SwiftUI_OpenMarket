//
//  ProductCreateView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductCreateView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  @ObservedObject var viewModel: ProductCreateViewModel
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

struct ProductCreateView_Previews: PreviewProvider {
  static var previews: some View {
    ViewFactory.preview.productCreateView()
      .environmentObject(ViewFactory.preview)
  }
}
