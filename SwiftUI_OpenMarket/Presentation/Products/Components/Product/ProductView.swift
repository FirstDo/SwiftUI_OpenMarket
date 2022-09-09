//
//  ProductView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductView: View {
  @EnvironmentObject var viewFactor: ViewFactory
  @ObservedObject var viewModel: ProductViewModel
  
  var body: some View {
    HStack(spacing: 16) {
      if viewModel.isLoading {
        ProgressView()
          .frame(width: 100, height: 100)
          .tint(.white)
          .background(.gray)
          .cornerRadius(20)
      } else {
        Image(uiImage: viewModel.image)
          .resizable()
          .aspectRatio(1, contentMode: .fit)
          .frame(width: 100, height: 100)
          .cornerRadius(20)
      }
      
      informationView
    }
    .padding()
  }
}

extension ProductView {
  private var discountView: some View {
    HStack {
      Text(viewModel.discountPercentage)
        .foregroundColor(.red)
        .font(.caption)
      Text(viewModel.price)
        .foregroundColor(.gray)
        .font(.caption)
        .strikethrough()
    }
  }
  
  private var informationView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(viewModel.name)
        .font(.title2)
        .lineLimit(2)
      
      if viewModel.isSale {
        discountView
      }
      
      Text(viewModel.bargainPrice)
        .fontWeight(.bold)
      Spacer()
      HStack {
        Spacer()
        Image(systemName: viewModel.isLike ? "star.fill" : "star")
          .foregroundColor(.yellow)
          .onTapGesture {
            viewModel.starButtonDidTap()
          }
      }
    }
  }
}

struct ProductView_Previews: PreviewProvider {
  static var previews: some View {
    ViewFactory.preview.productView(with: Product.preview)
    .environmentObject(ViewFactory.preview)
    .previewLayout(.fixed(width: 400, height: 130))
  }
}
