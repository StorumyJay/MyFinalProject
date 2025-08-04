//
//  Haul_TransportApp.swift
//  Haul-Transport
//
//  Created by Trenton Simmons on 7/29/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

    return true
  }
}

@main
struct Haul_TransportApp: App {
  
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
       
      // @State private var viewModel = MainViewModel() //BUG !!!
      @StateObject private var viewModel = MainViewModel() //Fix
       
       @State private var rootViewID = UUID()
       
       
       var body: some Scene {
           WindowGroup {
               NavigationStack {
                   currentView()
               }.id(rootViewID)
                   .onReceive(viewModel.$isAuthenticated){ isAuthenticated in
                       if !isAuthenticated {
                           rootViewID = UUID()
                       }
                   }
           
           }
       }
       
       
       @ViewBuilder
          private func currentView() -> some View {
              if viewModel.isAuthenticated {
                  UserProfileView(mainViewModel: viewModel)
              } else {
                  AuthView(mainViewModel: viewModel)
              }
          }
    
}
