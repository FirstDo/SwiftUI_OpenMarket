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
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        productListView
      }
      
      addProductButton
      
      NavigationLink(
        destination: viewFactory.productDetailView(with: viewModel.selectedProduct),
        isActive: $viewModel.showProductDetailView,
        label: { EmptyView() }
      )
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
          .onTapGesture {
            viewModel.productItemDidTap(product)
          }
          .onAppear {
            viewModel.request(index)
          }
        Divider()
          .background(.gray)
      }
    }
  }
  
  private var addProductButton: some View {
    Button {
      viewModel.addProductButtonDidTap()
    } label: {
      Image(systemName: "plus.circle.fill")
        .resizable()
        .background(.white)
        .frame(width: 50, height: 50)
        .cornerRadius(25)
        .tint(.orange)
    }
    .fullScreenCover(isPresented: $viewModel.showRegisterView) {
      NavigationView {
        viewFactory.productCreateView()
      }
    }

    .padding()
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
