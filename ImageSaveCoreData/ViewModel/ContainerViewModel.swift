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
}
