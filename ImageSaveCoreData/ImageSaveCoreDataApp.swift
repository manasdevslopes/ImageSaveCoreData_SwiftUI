//
//  ImageSaveCoreDataApp.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

@main
struct ImageSaveCoreDataApp: App {
  @StateObject var shareService = ShareService()
  
  let persistenceController = PersistenceController.shared
  
    var body: some Scene {
        WindowGroup {
            MyImagesGridView()
            .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
            .environmentObject(shareService)
            .onAppear {
              print("Documentry Directory", URL.documentsDirectory.path(percentEncoded: true))
            }
          /// - When JSON file received then it will open the url
            .onOpenURL { url in
              shareService.restore(url: url)
            }
        }
    }
}
