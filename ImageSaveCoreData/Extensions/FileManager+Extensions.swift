//
//  FileManager+Extensions.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 25/02/23.
//

import UIKit

enum fileType: String, CaseIterable {
  case JPG = "jpg"
  case JPEG = "jpeg"
  case PNG = "png"
}

extension FileManager {
  /// - Retrieve Image from File manager
  func retrieveImage(with id: String) -> UIImage? {
    guard let validUrl = getUrl(with: id) else { return nil }
    
    do {
      let imageData = try Data(contentsOf: validUrl)
      return UIImage(data: imageData)
    } catch {
      // print("Retrieve Imge------>", error.localizedDescription)
      return nil
    }
  }
  
  /// - Save Image to File Manager
  func saveImage(with id: String, image: UIImage) {
    let extn = imageFormat(image)
    guard let data = extn.1 else {
      print("Could not save Image")
      return
    }
    do {
        let url = URL.documentsDirectory.appendingPathComponent("\(id).\(extn.0)")
        try data.write(to: url)
      } catch {
        print("SAVEIMAGE Error----->", error.localizedDescription)
      }
  }
  
  /// - Delete Image from File manager
  func deleteImage(with id: String) {
    guard let validUrl = getUrl(with: id) else {
      print("File doesn't exists!")
      return
    }
    do {
      try removeItem(at: validUrl)
    } catch {
      print("RemoveItem----->", error.localizedDescription)
    }
  }
  
  func getUrl(with id: String) -> URL? {
    var fileTypesValues: [String] = []
    fileType.allCases.forEach { caseValue in
      fileTypesValues.append(caseValue.rawValue)
    }
    
    let documentsDirectory = URL.documentsDirectory
    let url = fileTypesValues.compactMap({ documentsDirectory.appendingPathComponent("\(id).\($0)")})
      .first(where: { fileExists(atPath: $0.path() )})
    return url
  }
  
  func imageFormat(_ image: UIImage) -> (String, Data?) {
    var imageData: Data?
    var fileExtension: String = fileType.JPG.rawValue
    if let pngData = image.pngData() {
      imageData = pngData
      fileExtension = fileType.PNG.rawValue
    } else if let jpegData = image.jpegData(compressionQuality: 1.0) {
      imageData = jpegData
      fileExtension = fileType.JPG.rawValue
    }
    return (fileExtension, imageData)
  }
  
  /// - After receiving jsonString & filename with custom extension myimg from ShareService's saveMyImage func, here this func will create a path
  func saveJSON(_ json: String, fileName: String) {
    let url = URL.documentsDirectory.appending(path: fileName)
    do {
      try json.write(to: url, atomically: false, encoding: .utf8)
    } catch {
      print("Couldn't save json")
    }
  }
  
  /// - When recieved url from someone else in json format then need to decode it
  func decodeJSON(from url: URL) -> CodableImage? {
    do {
      let data = try Data(contentsOf: url)
      do {
        return try JSONDecoder().decode(CodableImage.self, from: data)
      } catch {
        print("DECODE_JSON_DATA", error.localizedDescription)
        return nil
      }
    } catch {
      print("DECODE_JSON", error.localizedDescription)
      return nil
    }
  }
  
  // Unzipped
  func moveFile(oldURL: URL, newURL: URL) {
    if fileExists(atPath: newURL.path) {
      try? removeItem(at: newURL)
    }
    do {
      try moveItem(at: oldURL, to: newURL)
    } catch {
      print("moveFile_error", error.localizedDescription)
    }
  }
}
