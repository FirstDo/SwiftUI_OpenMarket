//
//  FormDataBuilder.swift
//  SwiftUI_OpenMarket
//
//  Created by dudu on 2022/09/09.
//

import Foundation

final class FormDataBuilder {
  private var data = Data()
  private let boundary: String
  private var boundaryPrefix: String { "--\(boundary)\r\n" }
  private var boundarySuffix: String { "\r\n--\(boundary)--\r\n" }
  
  private init(boundary: String) {
    self.boundary = boundary
  }
  
  static func shared(token: String) -> FormDataBuilder {
    return FormDataBuilder(boundary: token)
  }
  
  @discardableResult
  func append(_ form: FormData) -> Self {
    guard let formData = form.data else { return self }
    
    self.data.appendString(boundaryPrefix)
    self.data.appendString("Content-Disposition: form-data; name=\"\(form.name)\"")
    
    if let filename = form.filename {
      data.appendString("; filename=\"\(filename)\"")
    }
    self.data.appendString("\r\n")
    self.data.appendString("Content-Type: \(form.type.rawValue)\r\n\r\n")
    self.data.append(formData)
    return self
  }
  
  func append(_ forms: [FormData]) -> Self {
    forms.forEach { self.append($0) }
    return self
  }
  
  func make() -> Data {
    self.data.appendString(boundarySuffix)
    return self.data
  }
}

enum MIMEType: String {
  case json = "application/json"
  case png = "image/png"
  case jpeg = "image/jpeg"
}

struct FormData {
  let name: String
  let type: MIMEType
  var data: Data?
  var filename: String?
}

private extension Data {
  mutating func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
