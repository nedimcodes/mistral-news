//
//	MainNavigationView
//  News
//	Created by: @nedimf on 30/04/2022


import SwiftUI
import Awesome

struct MainNavigationView: View {
    let deviceNotificationManager = DeviceNotificationManager()
    var body: some View {
        TabView{
            HeadlinesView(enteredFromTab: true)
                .tabItem {
                    Awesome.Solid.newspaper.image
                    Text("Headlines")
                }.tag(1)
            SearchView(enteredFromTabController: true)
                .tabItem {
                    Awesome.Solid.search.image
                    Text("Search")
                }
                .tag(2)
        }
        .onAppear {
            deviceNotificationManager.askForPermission()
            var interval = 60.0
            #if DEBUG
            interval = 25.0
            #endif
            Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                BackgroundFetchManager().doBackgroundFetchForKeywords()
            }
        }
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
