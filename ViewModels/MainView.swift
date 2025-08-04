//  MainViewModel.swift
//  AuthApp
//
//  Created by Mikaila Akeredolu on 7/14/25.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


@MainActor
class MainViewModel: ObservableObject, Sendable {
    
    @Published var showToast: Bool = false
    @Published var toastMessage: String = ""
    
    //Auth properties
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var isPasswordVisible: Bool = false
    @Published var showSignInView: Bool = false
    
    @Published var authUserData: UserData? = nil
    @Published var isAuthenticated: Bool = false
    @Published var databaseUser: DatabaseUser? = nil
    
    init(){
        checkAuthenticationStatus()
        fetchCurrentUserEmail()
    }
    
    private func checkAuthenticationStatus() {
        DispatchQueue.main.async {
//unwrap user with Auth FirebaseAuth to get the currentUser
            if let user = Auth.auth().currentUser {
                
                self.isAuthenticated = true
                self.authUserData = UserData(user: user)
                
            }else{
                
                self.isAuthenticated = false
                self.authUserData = nil
                
            }
            
        }
        
    }

    
    
    func signOut() {
     
         do {
             //signout of firebase
             try Auth.auth().signOut()
             
             //set user to false and nil
             DispatchQueue.main.async {
                 self.isAuthenticated = false
                 self.authUserData = nil
             }
             
         } catch {
             print("Error signing out: \(error)")
         }
         
     }
    
    
    private func showToastMessage(_ message: String) {
         
     DispatchQueue.main.async {
             
         self.toastMessage = message
         self.showToast = true
             //async - setting a timer
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                     self.showToast = false
             }
             
         }
     }

    
    
    private func handleAutherror(_ error: Error) {
        if let error = error as? NSError,
           let errorMessage = error.userInfo[NSLocalizedDescriptionKey] as? String {
                showToastMessage(errorMessage)
        }else{
                showToastMessage("An unknown error occured")
        }
    }
    
    

    
    //Sign In Functionality
        
        func signIn()  {
            // Abouncer at the door
            guard !email.isEmpty, !password.isEmpty else {
                print("Email or password are empty")
                return
            }
            
            //async await functionality
            Task{
                do {
                    
                    let result =  try await Auth.auth().signIn(withEmail: email, password: password)
                    
                    //Grab user property from result
                    DispatchQueue.main.async {
                        self.authUserData = UserData(user: result.user)
                        self.isAuthenticated = true
                    }
                    
                    print("Signed in successfully")
                    
                } catch {
                    DispatchQueue.main.async {
                        self.handleAutherror(error)
                    }
                }
                
            }
            
        }

    
    //SignUp Functionaility
     func signUp() {
         
         guard !email.isEmpty, !password.isEmpty else {
             print("Email or password are empty")
             return
         }
         
         Task{
             do {
                 
                 let result =  try await Auth.auth().createUser(withEmail: email, password: password)
                 
                 //create a new user with the result from their email and password
                         let userData = UserData(user: result.user)
                                        
                         //populate a new user's data as a document object in firestore collection
                         let db = Firestore.firestore()
                                            
                         // create a database user with our Model
                         let databaseUser = DatabaseUser(userID: userData.uid, username: username, email: userData.email, dateCreated: Date())
                                      
                         //store it in FirebaseFirestore as a document
                         try db.collection("users").document(userData.uid).setData(from: databaseUser, merge: false)
                                    
                 
                 DispatchQueue.main.async {
                     self.authUserData = UserData(user: result.user)
                     self.isAuthenticated = true
                 }
                 
                 print("Created user successfully")
                 
             } catch {
                 DispatchQueue.main.async {
                     self.handleAutherror(error)
                 }
             }
         }
         
     }
    
//
    func fetchCurrentUserEmail() {
              if let user = Auth.auth().currentUser {
                  self.email = user.email ?? "Unknown Email"
              }
    }
    
    

  
    //Fetch User form Firestore Database with their uid and return a db user with an async fucntion
          private func fetchDatabaseUser(withUID uid: String) async throws -> DatabaseUser {
              let db = Firestore.firestore()
              return try await db.collection("users").document(uid).getDocument(as: DatabaseUser.self)
          }
          
        
        //public function to fetch databse user with private asyn version above it
          
          func fetchUserData(){
              
              //get the uid
              guard let uid = Auth.auth().currentUser?.uid else {
                  return
              }
              
              Task {
                  do {
                      let databaseUser = try await fetchDatabaseUser(withUID: uid)
                      //open a dispatch que
                      DispatchQueue.main.async {
                          self.databaseUser = databaseUser //assign the db user found  by id to global state
                          print("Fetched user data successfully: \(databaseUser)")
                      }
                  } catch {
                      print("Error occured while fetching user data from db: \(error.localizedDescription)")
                  }
              }
          }
        
        


    
    
    
} //end of my class


extension MainViewModel {
    func isValidEmail( ) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return !password.isEmpty && emailPredicate.evaluate(with: email)
    }
}







