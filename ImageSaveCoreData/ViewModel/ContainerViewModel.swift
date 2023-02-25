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
  
  func createNewObject(name: String, image: UIImage) {
    let newImage = MyImage(context: viewContext)
    newImage.id = UUID().uuidString
    newImage.name = name
    saveData()
    FileManager().saveImage(with: newImage.imageID, image: image)
  }
  
  func deleteObject(_ selectedObject: MyImage) {
    viewContext.delete(selectedObject)
    saveData()
  }
}
