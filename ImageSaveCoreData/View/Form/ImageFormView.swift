//
//  ImageFormView.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

struct ImageFormView: View {
  @State private var showPicker: Bool = false
  @State private var croppedImage: UIImage?
  
  @ObservedObject var viewModel: FormViewModel
  
  @Environment(\.dismiss) var dismiss
  
    var body: some View {
      NavigationStack {
        VStack {
          Image(uiImage: viewModel.uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 400)
          TextField("Image Name", text: $viewModel.name)
            .textFieldStyle(.roundedBorder)
          
          HStack {
            if viewModel.updating {
              Button {
                self.showPicker.toggle()
              } label: {
                Text("Update Image").font(.footnote.bold()).foregroundColor(.blue)
              }
              .padding(8)
              .background(Color.blue.opacity(0.3))
              .clipShape(Capsule())
              .shadow(color: Color.blue.opacity(0.6), radius: 5, x: 0, y: 5)
            }
            
            Button {
//              if viewModel.updating {
//
//              } else {
//
//              }
              dismiss()
            } label: {
              Image(systemName: "checkmark")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(viewModel.inComplete)
          }
          Spacer()
          
          
        }
        .padding()
        .navigationTitle(viewModel.updating ? "Update Image" : "New Image")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              dismiss()
            }
            .buttonStyle(.bordered)
          }
          if viewModel.updating {
            ToolbarItem(placement: .navigationBarTrailing) {
              Button {
                // TODO: - Delete Functions
                dismiss()
              } label: {
                Image(systemName: "trash").foregroundColor(.red)
              }
              .buttonStyle(.borderedProminent)
              .tint(.red.opacity(0.3))
            }
          }
        }
      }
      .cropImagePicker(options: [.circle, .rectangle, .square, .custom(.init(width: 200, height: 200))], show: $showPicker, croppedImage: $croppedImage)
      .onChange(of: croppedImage) { newValue in
        if let newValue {
          viewModel.uiImage = newValue
        }
      }
    }
}

struct ImageFormView_Previews: PreviewProvider {
    static var previews: some View {
      ImageFormView(viewModel: FormViewModel(UIImage(systemName: "photo")!))
    }
}
