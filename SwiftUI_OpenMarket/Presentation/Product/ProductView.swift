//
//  ProductView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductView: View {
  
  @ObservedObject var viewModel: ProductViewModel
  
  var body: some View {
    HStack(spacing: 16) {
      Image(uiImage: viewModel.image)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(20)
        
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
        .font(.title3)
      
      if viewModel.isSale {
        discountView
      }
      
      Text(viewModel.bargainPrice)
      Spacer()
      HStack {
        Spacer()
        Image(systemName: viewModel.isLike ? "star.fill" : "star")
          .foregroundColor(.yellow)
      }
    }
  }
}

struct ProductView_Previews: PreviewProvider {
  static var previews: some View {
    ProductView(viewModel: ProductViewModel(
      product: Product.preview,
      imageDownloader: DefaultImageDownloader(cacheManager: ImageCacheManager())
    ))
      .previewLayout(.fixed(width: 400, height: 130))
  }
}
