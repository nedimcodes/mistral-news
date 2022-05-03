//
//	NewsApp
//  News
//	Created by: @nedimf on 29/04/2022


import SwiftUI

@main
struct NewsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate    
    var body: some Scene {
        WindowGroup {
            MainNavigationView()
        }
    }
}
