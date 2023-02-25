//
//  MyImagesGridView.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

struct MyImagesGridView: View {
  @EnvironmentObject var vm: ContainerViewModel
  
  @State private var showPicker: Bool = false
  @State private var croppedImage: UIImage?
  @State private var formType: FormType?
  
  let columns = [GridItem(.adaptive(minimum: 100))]
  
  var body: some View {
    NavigationStack {
      Group {
//        if let croppedImage {
//          Image(uiImage: croppedImage)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 300, height: 400)
//        } else {
//          Text("No Image is Selected")
//            .font(.caption)
//            .foregroundColor(.gray)
//        }
        
        if !vm.imageEntity.isEmpty {
          ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
              ForEach(vm.imageEntity) { myImage in
                Button {
                  formType = .update(myImage)
                } label: {
                  VStack {
                    Image(uiImage: myImage.uiimage)
                      .resizable().scaledToFill()
                      .frame(width: 100, height: 100).clipped()
                      .shadow(radius: 5)
                    Text(myImage.nameView)
                  }
                }

              }
            }
          }
        } else {
          Text("Select your first image")
        }
      }
      .navigationTitle("My Images 🌆")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            self.showPicker.toggle()
          } label: {
            Text("New Image")
              .alignmentGuide(HorizontalAlignment.center) { d in
                d[HorizontalAlignment.center]
              }
              .font(.footnote.bold()).foregroundColor(.blue)
          }
          .padding(8)
          .background(Color.blue.opacity(0.3))
          .clipShape(Capsule())
          .shadow(color: Color.blue.opacity(0.6), radius: 5, x: 0, y: 5)
        }
      }
      .cropImagePicker(options: [.circle, .rectangle, .square, .custom(.init(width: 200, height: 200))], show: $showPicker, croppedImage: $croppedImage)
      .onChange(of: croppedImage) { newValue in
        if let newValue {
          formType = .new(newValue)
        }
      }
      .sheet(item: $formType) { $0 }
    }
  }
}

struct MyImagesGridView_Previews: PreviewProvider {
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    MyImagesGridView()
      .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
  }
}
