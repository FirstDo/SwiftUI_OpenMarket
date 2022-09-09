//
//  PromotionView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct PromotionView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  @ObservedObject var viewModel: PromotionViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      promotionBannerView
      
      Section {
        hotItemsView
      } header: {
        hotItemsHeaderView
      }
      
      NavigationLink(
        destination: viewFactory.productDetailView(with: viewModel.selectedProduct),
        isActive: $viewModel.showProductDetailView,
        label: { EmptyView() }
      )
    }
    .padding()
    .navigationTitle("🎁 행사중")
    .onAppear {
      viewModel.requestProduct(10)
    }
  }
}

extension PromotionView {
  var promotionBannerView: some View {
    TabView {
      ForEach(viewModel.promotions, id: \.name) { promotion in
        Image(promotion.name)
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .cornerRadius(20)
          .onTapGesture {
            viewModel.openURL(to: promotion.url)
          }
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .frame(
      width: UIScreen.main.bounds.size.width - 30,
      height: UIScreen.main.bounds.size.width - 30
    )
    .padding()
  }
  
  var hotItemsHeaderView: some View {
    HStack {
      Text("🚨 이 상품 놓치지 마세요!")
        .font(.title2)
        .fontWeight(.bold)
        .padding(.leading)
      Spacer()
      NavigationLink("more ➡️") {
        viewFactory.productMainView()
      }
      .tint(.black)
    }
  }
  
  var hotItemsView: some View {
    let gridItems = [GridItem(.flexible(maximum: 200))]
    
    return ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: gridItems) {
        ForEach(viewModel.products) { product in
          viewFactory.productGridView(with: product)
            .onTapGesture {
              viewModel.productItemDidTap(product)
            }
        }
      }
    }
  }
}

struct PromotionView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ViewFactory.preview.promotionView()
        .environmentObject(ViewFactory.preview)
    }
  }
}
