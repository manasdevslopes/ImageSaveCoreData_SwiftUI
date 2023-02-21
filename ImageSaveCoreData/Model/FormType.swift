//
//  FormType.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

enum FormType: Identifiable, View {
  case new(UIImage)
  case update(MyImage)
  
  var id: String {
    switch self {
      case .new:
        return "new"
      case .update:
        return "update"
    }
  }
  
  var body: some View {
    switch self {
      case .new(let uiimage):
        return ImageFormView(viewModel: FormViewModel(uiimage))
      case .update(let myImage):
        return ImageFormView(viewModel: FormViewModel(myImage))
    }
  }
}
