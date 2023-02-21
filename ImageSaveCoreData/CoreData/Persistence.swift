//
//  Persistence.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "MyImagesDataModel")
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Error loading core data: \(error), \(error.userInfo), \(error.localizedDescription) 🔴")
        return
      } else {
        print("Successfully loaded Core Data! ✅")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
