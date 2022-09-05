//
//  PageView.swift
//  SwiftUI_OpenMarket
//
//  Created by 김도연 on 2022/09/06.
//

import SwiftUI

struct PageControlView: View {
  
  let numberOfPages: Int
  @Binding var currentPage: Int
  
  var body: some View {
    HStack {
      ForEach(0..<numberOfPages) { index in
        Circle()
          .frame(width: 10, height: 10)
          .foregroundColor(index == currentPage ? .black : .white)
      }
    }
    .padding(10)
    .background(.black.opacity(0.2))
    .cornerRadius(20)
  }
}

struct PageControlView_Previews: PreviewProvider {
  static var previews: some View {
    PageControlView(numberOfPages: 5, currentPage: .constant(3))
      .previewLayout(.sizeThatFits)
  }
}
