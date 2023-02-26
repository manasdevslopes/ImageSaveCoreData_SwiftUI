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
  @Published var comment = ""
  @Published var date = Date.distantPast
  @Published var receivedFrom = ""
  
  var dateHidden: Bool {
    date == Date.distantPast
  }
  
  var id: String?
  
  var updating: Bool { id != nil }
  
  // for adding
  init(_ uiimage: UIImage) {
    self.uiImage = uiimage
  }
  
  // for updating
  init(_ myImage: MyImage) {
    name = myImage.nameView
    uiImage = myImage.uiimage
    id = myImage.imageID
    comment = myImage.commentView
    date = myImage.dateTaken ?? Date.distantPast
    receivedFrom = myImage.receivedFromView
  }
  
  var inComplete: Bool {
    name.isEmpty || uiImage == UIImage(systemName: "photo")!
  }
}
