//
//	DeviceNotificationManager
//  NSObject that handles notification building and permission requests
//  News
//	Created by: @nedimf on 02/05/2022


import Foundation
import UserNotifications

enum NotificationDefaults: String{
    case didAllowFirstTimeNotifications = "didAllowFirstTimeNotifications"
    case disallowedNotifications = "disallowedNotifications"
    case allowedNotifications = "allowedNotifications"
}
class DeviceNotificationManager: NSObject{
    
    let userDefaults = UserDefaults()
    
    ///Asks for permission to send notifications, saves user response as 3 different states
    func askForPermission(){
        if !userDefaults.bool(forKey: NotificationDefaults.didAllowFirstTimeNotifications.rawValue){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                if granted {
                    self.userDefaults.set(true, forKey: NotificationDefaults.allowedNotifications.rawValue)
                    self.userDefaults.set(true, forKey: NotificationDefaults.didAllowFirstTimeNotifications.rawValue)

                } else {
                    self.userDefaults.set(true, forKey: NotificationDefaults.disallowedNotifications.rawValue)
                    self.userDefaults.set(true, forKey: NotificationDefaults.didAllowFirstTimeNotifications.rawValue)
                }
            }
        }
    }
    
    ///Creates notification for provided keyword,
    ///and sends encoded headline object as notification payload
    ///- Parameter keyword:String
    ///- Parameter headline:Headline
    func createNotification(keyword: String, headline: Headline){
        let content = UNMutableNotificationContent()
        content.title = "New Headline for \(keyword.capitalized)"
        content.subtitle = "Scheduled Alert"
        content.body = headline.title ?? ""
        content.sound = .default
        content.categoryIdentifier = "NewsCategory"
        
        do {
            let payload = try JSONEncoder().encode(headline)
            content.userInfo = ["PayloadArticle": payload]
        }catch(let error){
            print(#function, error)
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
          if let error = error {
            print(error)
          }
        }
    }
}
