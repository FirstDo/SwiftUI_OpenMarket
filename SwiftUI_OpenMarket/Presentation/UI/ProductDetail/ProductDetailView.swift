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
  @Environment(\.dismiss) var dismiss
  
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
        }
        .padding()
      }
      
      footerView
    }
    .alert(
      viewModel.alert.title,
      isPresented: $viewModel.showAlert,
      actions: {
        Button("확인") {
          viewModel.deleteSuccessButtonDidTap()
        }
      },
      message: {
        Text(viewModel.alert.message ?? "")
      }
    )
    .onChange(of: viewModel.dismissView) { newValue in
      if newValue {
        dismiss()
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        deleteButton
      }
    }
    .onAppear {
      viewModel.requestProduct()
    }
  }
}

extension ProductDetailView {
  private var deleteButton: some View {
      Button(role: .destructive) {
        viewModel.deleteButtonDidTap()
      } label: {
        Label("삭제", systemImage: "trash.circle")
      }
      .disabled(!viewModel.isOwner)
      .opacity(viewModel.isOwner ? 1.0 : 0.0)
      .foregroundColor(.red)
  }
  
  private var productImagePageView: some View {
    TabView {
      ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
        Image(uiImage: image)
          .cellStyle(size: UIScreen.main.bounds.size.width - 30, radius: 20)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .frame(
      width: UIScreen.main.bounds.size.width - 30,
      height: UIScreen.main.bounds.size.width - 30
    )
  }
  
  private var profileView: some View {
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
  
  private var footerView: some View {
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
      ViewFactory.preview.productDetailView(with: Product.preview, updateTrigger: { })
        .environmentObject(ViewFactory.preview)
    }
  }
}
