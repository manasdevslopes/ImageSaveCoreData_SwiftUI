//
//  ImageSaveCoreDataApp.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

@main
struct ImageSaveCoreDataApp: App {
  let persistenceController = PersistenceController.shared
  
    var body: some Scene {
        WindowGroup {
            MyImagesGridView()
            .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
        }
    }
}
