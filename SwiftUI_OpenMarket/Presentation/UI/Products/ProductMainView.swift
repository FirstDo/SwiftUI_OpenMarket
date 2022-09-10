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
      productListView
        
      addProductButton
      
      NavigationLink(
        destination: viewFactory.productDetailView(
          with: viewModel.selectedProduct,
          updateTrigger: viewModel.refresh
        ),
        isActive: $viewModel.showProductDetailView,
        label: { EmptyView() }
      )
    }
    .navigationTitle("모든 상품")
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension ProductMainView {
  private var productListView: some View {
    List {
      ForEach(Array(viewModel.results.enumerated()), id: \.element.id) { (index, product) in
        viewFactory.productView(with: product)
          .onTapGesture {
            viewModel.productItemDidTap(product)
          }
          .onAppear {
            viewModel.request(index)
          }
      }
    }
    .listStyle(.plain)
    .searchable(text: $viewModel.query, prompt: "어떤 물건을 찾아볼까요?")
    .refreshable {
      viewModel.refresh()
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
    .padding()
    .fullScreenCover(isPresented: $viewModel.showRegisterView) {
      NavigationView {
        viewFactory.productRegisterView(viewModel.refresh)
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
