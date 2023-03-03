//
//  ShareService.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 26/02/23.
//

import Foundation
import ZIPFoundation

struct CodableImage: Codable, Equatable {
  let comment: String
  let dateTaken: Date
  let id: String
  let name: String
  let receivedFrom: String
}

class ShareService: ObservableObject {
  @Published var codeableImage: CodableImage?
  
  static let ext = "myimg"
  
  /// - After share button clicked, all the data will be send here in the form of CodableImage Struct and then send it FileManager SaveJSON() func.
  func saveMyImage(_ codableImage: CodableImage) {
    let filename = "\(codableImage.id).json"
    do {
      let data = try JSONEncoder().encode(codableImage)
      let jsonString = String(decoding: data, as: UTF8.self)
      FileManager().saveJSON(jsonString, fileName: filename)
      zipFiles(id: codableImage.id)
    } catch {
      print("Couldn't encode data")
    }
  }
  
  /// - while getting the url, then extension needs to be equal to ext, then it will be send to FileManager() decodeJSON func then the response will be saved to optional published ppt.
  func restore(url: URL) {
    let fileName = url.lastPathComponent
    let jsonName = fileName.replacingOccurrences(of: ShareService.ext, with: "json")
    let zipName = fileName.replacingOccurrences(of: ShareService.ext, with: "zip")
    let imgName = fileName.replacingOccurrences(of: ShareService.ext, with: "png") // TODO: - check for JPG or PNG
    let imgURL = URL.documentsDirectory.appending(path: imgName)
    let zipURL = URL.documentsDirectory.appending(path: zipName)
    let unzippedJSONURL = URL.documentsDirectory.appending(path: jsonName)
    
    if url.pathExtension == Self.ext {
      try? FileManager().moveItem(at: url, to: zipURL)
      try? FileManager().removeItem(at: imgURL)
      do {
        try FileManager().unzipItem(at: zipURL, to: URL.documentsDirectory)
      } catch {
        print(error.localizedDescription)
      }
      if let codeableImage = FileManager().decodeJSON(from: URL.documentsDirectory.appending(path: jsonName)) {
        self.codeableImage = codeableImage
      }
    }
    try? FileManager().removeItem(at: zipURL)
    try? FileManager().removeItem(at: unzippedJSONURL)
  }
  
  // Zipped both image url from FileManager and jsonFile from fileManager
  func zipFiles(id: String) {
    let archiveUrl = URL.documentsDirectory.appending(path: "\(id).\(Self.ext)")
    guard let archive = Archive(url: archiveUrl, accessMode: .create) else { return } // This creates an empty archive
    
    // Image Url with correct extension (JPG , PNG etc...)
    guard let imageURL = FileManager().getUrl(with: id) else { return }
    // JSON path of remaining data
    let jsonURL = URL.documentsDirectory.appending(path: "\(id).json")
    
    do {
      try archive.addEntry(with: imageURL.lastPathComponent, relativeTo: URL.documentsDirectory)
      try archive.addEntry(with: jsonURL.lastPathComponent, relativeTo: URL.documentsDirectory)
      try FileManager().removeItem(at: jsonURL)
    } catch {
      print("ZIPPEDFILES_error", error.localizedDescription)
    }
  }
}
