//
//  ImageFormView.swift
//  ImageSaveCoreData
//
//  Created by MANAS VIJAYWARGIYA on 31/01/23.
//

import SwiftUI

struct ImageFormView: View {
  @EnvironmentObject var vm: ContainerViewModel
  @EnvironmentObject var shareService: ShareService
  @Environment(\.dismiss) var dismiss
  @ObservedObject var viewModel: FormViewModel
  @State private var showPicker: Bool = false
  @State private var croppedImage: UIImage?
  @State private var share: Bool = false
  @State private var name: String = ""
  @State private var sendMail: Bool = false
  @State private var email = EmailForm()
  
  var body: some View {
    NavigationStack {
      VStack {
        Image(uiImage: viewModel.uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 400)
        TextField("Image Name", text: $viewModel.name)
        TextField("Comment", text: $viewModel.comment, axis: .vertical)
        
        HStack {
          Text("Date Taken")
          Spacer()
          if viewModel.dateHidden {
            Text("No Date")
            Button("Set Date") {
              viewModel.date = Date()
            }
          } else {
            HStack {
              DatePicker("", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
              Button("Clear Date") {
                viewModel.date = Date.distantPast
              }
            }
          }
        }
        .padding()
        .buttonStyle(.bordered)
        
        if !viewModel.receivedFrom.isEmpty {
          Text("**Received From**: \(viewModel.receivedFrom)")
        }
        
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
            if viewModel.updating {
              updateImage()
            } else {
              vm.createNewObject(name: viewModel.name, image: viewModel.uiImage, comment: viewModel.comment, date: viewModel.date)
            }
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
      .textFieldStyle(.roundedBorder)
      .disabled(!viewModel.receivedFrom.isEmpty)
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
            HStack {
              /// - Delete Button
              Button {
                /// - Delete Functions
                if let selectedObject = vm.imageEntity.first(where: { $0.id == viewModel.id }) {
                  FileManager().deleteImage(with: selectedObject.imageID)
                  vm.deleteObject(selectedObject)
                }
                dismiss()
              } label: {
                Image(systemName: "trash").foregroundColor(.red)
              }
              .buttonStyle(.borderedProminent)
              .tint(.red.opacity(0.3))
              
              /// - Share Button
              Button {
                updateImage()
                share.toggle()
              } label: {
                Image(systemName: "square.and.arrow.up")
              }
            }
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
    .alert("Your Name", isPresented: $share) {
      TextField("Your Name", text: $name)
      Button("Ok") {
        if let id = viewModel.id {
          viewModel.receivedFrom = viewModel.receivedFrom.isEmpty ? name : viewModel.receivedFrom + "->" + name
          let codableImage = CodableImage(comment: viewModel.comment,
                                          dateTaken: viewModel.date,
                                          id: id,
                                          name: viewModel.name,
                                          receivedFrom: viewModel.receivedFrom)
          shareService.saveMyImage(codableImage)
          
          // Mail
          email.messageHeader = "Sent from the My Images CoreData App"
          email.fileName = "\(id).\(ShareService.ext)"
          email.mimeType = "application/zip"
          let attachmentURL = URL.documentsDirectory.appending(path: email.fileName)
          if let data = try? Data(contentsOf: attachmentURL) {
            email.data = data
          }
          if MailView.canSendMail {
            sendMail.toggle()
          } else {
            print("This device doesn't support email.")
            dismiss()
          }
          try? FileManager().removeItem(at: attachmentURL)
        }
      }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("Please enter your name")
    }
    .sheet(isPresented: $sendMail) {
      MailView(mailForm: $email) { result in
        switch result {
          case .success:
            print("Email sent")
          case .failure(let error):
            print("Email_error", error.localizedDescription)
        }
        dismiss()
      }
    }
  }
  
  func updateImage() {
    if let id = viewModel.id,
       let selectedObject = vm.imageEntity.first(where: { $0.id == id }) {
      selectedObject.name = viewModel.name
      selectedObject.comment = viewModel.comment
      selectedObject.dateTaken = viewModel.date
      FileManager().saveImage(with: id, image: viewModel.uiImage)
      vm.saveData()
    }
  }
}

struct ImageFormView_Previews: PreviewProvider {
  static var previews: some View {
    let persistenceController = PersistenceController.shared
    ImageFormView(viewModel: FormViewModel(UIImage(systemName: "photo")!))
      .environmentObject(ContainerViewModel(context: persistenceController.container.viewContext))
      .environmentObject(ShareService())
  }
}
