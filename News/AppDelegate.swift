//
//	AppDelegate
//  News
//	Created by: @nedimf on 02/05/2022


import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    let backgroundFetchManger = BackgroundFetchManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureUserNotifications()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "ba.mistral.fetchNews",
                                        using: .main) { (task) in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        DispatchQueue.main.async {
            self.scheduleBackgroundFetch()
        }
        
        return true
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("Cancel")
        }
        backgroundFetchManger.doBackgroundFetchForKeywords()
    }
    
    ///- Warning: To correctly test background fetch be sure to send to lldb:
    ///
    ///```e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"ba.mistral.fetchNews"]```
    func scheduleBackgroundFetch() {
        let fetchTask = BGAppRefreshTaskRequest(identifier: "ba.mistral.fetchNews")
        fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(fetchTask)
        } catch {
            print("Unable to submit task: \(error)")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(.banner)
    }
    
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        func handleOpen(){
            let userInfo = response.notification.request.content.userInfo
            if let payloadData = userInfo["PayloadArticle"] as? Data {
                if let payload = try? JSONDecoder().decode(Headline.self, from: payloadData) {
                    if let payloadURL = payload.url{
                        if let url = URL(string: payloadURL) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
        
        if response.actionIdentifier == "openNews" {
            handleOpen()
        }
        handleOpen()
        completionHandler()
    }
    
    func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        let openNews = UNNotificationAction(
            identifier: "openNews",
            title: "Open",
            options: [.foreground])
        
        let category = UNNotificationCategory(
            identifier: "NewsCategory",
            actions: [openNews],
            intentIdentifiers: [],
            options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }
}

