//
//  TuneInApp.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI
import Firebase

@main
struct TuneInApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            MonthsView().environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UITextView.appearance().backgroundColor = .clear
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.gray]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        return true
    }
}
