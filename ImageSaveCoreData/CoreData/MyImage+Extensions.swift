//
//  MyImage+Extensions.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import UIKit

extension MyImage {
  var nameView: String {
    name ?? ""
  }
  
  var imageID: String {
    id ?? ""
  }
  
  var uiimage: UIImage {
    if !imageID.isEmpty,
       let image = FileManager().retrieveImage(with: imageID) {
      return image
    } else {
      return UIImage(systemName: "photo")!
    }
  }
}
