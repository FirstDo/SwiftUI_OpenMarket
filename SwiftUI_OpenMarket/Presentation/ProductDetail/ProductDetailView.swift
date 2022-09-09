//
//  ProductDetailView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductDetailView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  @ObservedObject var viewModel: ProductDetailViewModel
  
  var body: some View {
    VStack(spacing: 16) {
      ScrollView {
        VStack(alignment: .leading, spacing: 10) {
          productImagePageView
          profileView
          
          Divider()
          
          Text(viewModel.name)
            .font(.title2)
            .fontWeight(.bold)
          Text(viewModel.description)
            .lineLimit(nil)
        }
        .padding()
      }
      
      footerView
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        moreButton
          .disabled(!viewModel.isOwner)
          .opacity(viewModel.isOwner ? 1.0 : 0.0)
      }
    }
    .onAppear {
      viewModel.requestProduct()
    }
  }
}

extension ProductDetailView {
  var moreButton: some View {
    Menu {
      Button(role: .destructive) {
        viewModel.deleteButtonDidTap()
      } label: {
        Label("삭제", systemImage: "trash")
      }

      Button(role: .cancel) {
        viewModel.editButtonDidTap()
      } label: {
        Label("수정", systemImage: "square.and.pencil")
      }

    } label: {
      Image(systemName: "ellipsis.circle")
    }
  }
  
  var productImagePageView: some View {
    TabView {
      ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
        Image(uiImage: image)
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .cornerRadius(20)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .frame(
      width: UIScreen.main.bounds.size.width - 30,
      height: UIScreen.main.bounds.size.width - 30
    )
  }
  
  var profileView: some View {
    HStack(spacing: 16) {
      Image(systemName: "person.circle")
        .resizable()
        .aspectRatio(1.0, contentMode: .fit)
        .foregroundColor(.gray)
      Text(viewModel.venderName)
        .font(.title3)
        .fontWeight(.semibold)
      Spacer()
    }
    .frame(height: 50)
  }
  
  var footerView: some View {
    HStack(spacing: 16) {
      Image(systemName: viewModel.isLike ? "star.fill" : "star" )
        .foregroundColor(.yellow)
        .onTapGesture {
          viewModel.starImageDidTap()
        }
      Divider()
      
      VStack {
        if viewModel.isSale {
          Text(viewModel.price)
            .font(.callout)
            .foregroundColor(.gray)
            .strikethrough()
        }
        
        Text(viewModel.bargainPrice)
          .foregroundColor(.red)
          .bold()
      }
      
      Spacer()
      
      Text(viewModel.stock)
    }
    .frame(height: 50)
    .padding()
  }
}

struct ProductDetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ViewFactory.preview.productDetailView(with: Product.preview)
        .environmentObject(ViewFactory.preview)
    }
  }
}
