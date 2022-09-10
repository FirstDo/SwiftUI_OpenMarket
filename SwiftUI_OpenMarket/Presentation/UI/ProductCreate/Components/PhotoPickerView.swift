//
//  PhotoPicker.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/06.
//

import UIKit
import SwiftUI
import PhotosUI

struct PhotoPickerView: UIViewControllerRepresentable {
  @Environment(\.dismiss) private var dismiss
  @Binding var images: [UIImage]
  
  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 5
    configuration.filter = .images
    
    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = context.coordinator
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // empty
  }
  
  func makeCoordinator() -> Coordinator {
    PhotoPickerView.Coordinator(self)
  }
  
  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoPickerView
    
    init(_ parent: PhotoPickerView) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.dismiss()
      parent.images.removeAll()
      
      let itemProviders = results.map(\.itemProvider)
      let validItemProvider = itemProviders.filter { $0.canLoadObject(ofClass: UIImage.self) }
      
      for itemProvider in validItemProvider {
        itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
          guard let image = image as? UIImage else { return }
          
          DispatchQueue.main.async {
            self.parent.images.append(image)
          }
        }
      }
    }
  }
}
