//
//  ProductRegisterView.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import SwiftUI

struct ProductRegisterView: View {
  @EnvironmentObject var viewFactory: ViewFactory
  @ObservedObject var viewModel: ProductRegisterViewModel
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(spacing: 30) {
        productImagesView
        userInputView
      }
    }
    .padding()
    .sheet(isPresented: $viewModel.showPhotoPickerView) {
      PhotoPickerView(images: $viewModel.images)
    }
    .alert("에러 발생", isPresented: $viewModel.showAlertView) {
      Button("확인") {}
    } message: {
      Text(viewModel.errorMessage)
    }
    .onChange(of: viewModel.dismissView) { status in
      if status {
        dismiss()
      }
    }
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Image(systemName: "xmark")
          .onTapGesture {
            viewModel.closeButtonDidTap()
          }
      }
      
      ToolbarItem(placement: .confirmationAction) {
        Text("완료")
          .onTapGesture {
            viewModel.registerButtonDidTap()
          }
      }
    }
    .navigationTitle("상품 등록")
    .navigationBarTitleDisplayMode(.inline)
  }
}

extension ProductRegisterView {
  private var productImagesView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack {
        Image(systemName: "camera.viewfinder")
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .frame(width: 100, height: 100)
          .cornerRadius(10)
          .onTapGesture {
            viewModel.cameraImageDidTap()
          }
        
        ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index, image in
          Image(uiImage: image)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: 100, height: 100)
            .cornerRadius(10)
        }
      }
    }
  }
  
  private var userInputView: some View {
    VStack {
      TextField("상품명", text: $viewModel.title)
      Divider()
      
      TextField("￦ 가격", text: $viewModel.price)
        .keyboardType(.numberPad)
      Divider()
      
      TextField("할인금액 (가격보다 적어야 합니다)", text: $viewModel.discountPrice)
        .keyboardType(.numberPad)
      Divider()
      
      TextField("재고수량", text: $viewModel.stock)
        .keyboardType(.numberPad)
      Divider()
      
      TextEditor(text: $viewModel.description)
    }
  }
}

struct ProductRegisterView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ViewFactory.preview.productRegisterView({})
        .environmentObject(ViewFactory.preview)
    }
  }
}
