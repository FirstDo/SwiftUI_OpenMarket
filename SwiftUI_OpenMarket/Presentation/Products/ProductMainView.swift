//
//  ProductMainView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/05.
//

import SwiftUI

struct ProductMainView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  @ObservedObject var viewModel: ProductMainViewModel
  
  var body: some View {
    ScrollView {
      productListView
    }
    .onAppear {
      viewModel.request(0)
    }
    .navigationTitle("모든 상품")
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension ProductMainView {
  private var productListView: some View {
    LazyVStack {
      ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { (index, product) in
        viewFactory.productView(with: product)
          .frame(height: 150, alignment: .center)
          .onAppear {
            viewModel.request(index)
          }
        Divider()
          .background(.gray)
      }
    }
  }
}

struct ProductMainView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ViewFactory.preview.productMainView()
        .environmentObject(ViewFactory.preview)
    }
  }
}
