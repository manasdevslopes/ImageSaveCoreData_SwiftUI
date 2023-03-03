//
//  ContainerViewModel.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI
import CoreData

class ContainerViewModel: ObservableObject {
  @Published var imageEntity: [MyImage] = []
  
  private var viewContext: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.viewContext = context
    fetchData()
  }
}

extension ContainerViewModel {
  func fetchData() {
    let request: NSFetchRequest<MyImage> = MyImage.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \MyImage.name, ascending: true)]
    
    do {
      imageEntity = try viewContext.fetch(request)
    } catch let error {
      print("Error fetching Data. \(error.localizedDescription)")
      #if DEBUG
      assertionFailure()
      #endif
    }
  }
  
  func saveData() {
    if viewContext.hasChanges {
      try? viewContext.save()
      fetchData()
    }
  }
  
  func createNewObject(name: String, image: UIImage, comment: String, date: Date) {
    let newImage = MyImage(context: viewContext)
    newImage.id = UUID().uuidString
    newImage.name = name
    newImage.comment = comment
    newImage.dateTaken = date
    saveData()
    FileManager().saveImage(with: newImage.imageID, image: image)
  }
  
  func deleteObject(_ selectedObject: MyImage) {
    viewContext.delete(selectedObject)
    saveData()
  }
  
  // Below function is for Create a new Image Object on change of shareService.codeableImage
  func restoreMyImage(_ codeableImage: CodableImage?) {
    if let codeableImage {
      let newImage = MyImage(context: viewContext)
      newImage.id = codeableImage.id
      newImage.name = codeableImage.name
      newImage.comment = codeableImage.comment
      newImage.dateTaken = codeableImage.dateTaken
      newImage.receivedFrom = codeableImage.receivedFrom
      saveData()
    }
  }
  
  // Below function is for when shared image is an update of an existing image
  /// - codeableImage is the updated version of an object. myImage is an existing version of the same object
  func updateImageInfo(_ myImage: MyImage, _ codeableImage: CodableImage?) {
    if let codeableImage {
      myImage.id = codeableImage.id
      myImage.name = codeableImage.name
      myImage.comment = codeableImage.comment
      myImage.dateTaken = codeableImage.dateTaken
      myImage.receivedFrom = codeableImage.receivedFrom
      saveData()
    }
  }
}
