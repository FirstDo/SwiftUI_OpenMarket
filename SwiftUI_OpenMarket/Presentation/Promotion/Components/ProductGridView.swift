//
//  ProductView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductGridView: View {
  @EnvironmentObject var viewFactor: ViewFactory
  @ObservedObject var viewModel: ProductViewModel
  
  var body: some View {
    VStack {
      Image(uiImage: viewModel.image)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 0)
        .padding()
      Text(viewModel.name)
        .fontWeight(.semibold)
    }
  }
}

struct ProductGridView_Previews: PreviewProvider {
  static var previews: some View {
    ViewFactory.preview.productGridView(with: Product.preview)
    .environmentObject(ViewFactory.preview)
    .previewLayout(.fixed(width: 100, height: 120))
  }
}
