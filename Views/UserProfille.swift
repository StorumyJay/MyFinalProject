//  UserProfileView.swift
//  AuthApp
//
//  Created by Mikaila Akeredolu on 7/15/25.
//
import Foundation
import SwiftUI
import UIKit

//Profilemanger
class ProfileImageManager {
    static let shared = ProfileImageManager()
    private init() {}

    private let filename = "profile.jpg"

    private var fileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(filename)
    }

    func save(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    func load() -> UIImage? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

//    func delete() {
//        try? FileManager.default.removeItem(at: fileURL)
//    }
}


//Image picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


//UserProfileView
struct UserProfileView: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    //variables
       @State private var profileImage: UIImage? = nil
       @State private var showingImagePicker = false
       @State private var selectedImage: UIImage?
    
    
    var body: some View {
       
        ZStack{
            Color.yellow.ignoresSafeArea()
            VStack{
                
                Text("Welcome")
                    .font(.largeTitle)
                
//                Image(systemName: "person.fill")
//                    .font(.system(size:150))
             
                Text(" @\(mainViewModel.databaseUser?.username ?? "Unknown")")
                    .font(.largeTitle)
                
                //before picking image
                                    if let image = profileImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                            .shadow(radius: 4)
                                    } else {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 150, height: 150)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .font(.system(size: 100))
                                            )
                                    }

                                    Button("Change Picture") {
                                        showingImagePicker = true
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .padding(.top, 20)
                                    .padding(.bottom, 20)
                
                NavigationLink{
          
                    ContentView(mainViewModel: mainViewModel)
                    
                } label: {
                    Text("Get Started")
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                    
                    Image(systemName: "arrowshape.right.fill")
                        .resizable()
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .padding()
                }
                
  
              
            } //vstack ends here
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                if let selected = selectedImage {
                    ProfileImageManager.shared.save(image: selected)
                    profileImage = selected
                }
            }) {
                ImagePicker(image: $selectedImage)

            }
        }.onAppear{
            //mainViewModel.fetchCurrentUserEmail()
            mainViewModel.fetchUserData()
        }
        
    }
}

#Preview {
    UserProfileView(mainViewModel: MainViewModel())
}




/*
 //Text(mainViewModel.authUserData?.uid ?? "null")
             
//    Text("welcome \(mainViewModel.authUserData?.email ?? "null")")
//                Text("welcome \(mainViewModel.email)")
            // Text("You are now signed in")
 **/
