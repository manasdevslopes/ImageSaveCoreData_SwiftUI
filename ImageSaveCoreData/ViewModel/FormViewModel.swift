//
//  FormViewModel.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

class FormViewModel: ObservableObject {
  @Published var name: String = ""
  @Published var uiImage: UIImage
  
  var id: String?
  
  var updating: Bool { id != nil }
  
  // for adding
  init(_ uiimage: UIImage) {
    self.uiImage = uiimage
  }
  
  // for updating
  init(_ myImage: MyImage) {
    name = myImage.nameView
    uiImage = UIImage(systemName: "photo")!
    id = myImage.imageID
  }
  
  var inComplete: Bool {
    name.isEmpty || uiImage == UIImage(systemName: "photo")!
  }
}
