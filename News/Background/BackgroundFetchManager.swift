//
//	BackgroundFetchManager
//  NSObject that handles background fetch for stored keywords
//  News
//	Created by: @nedimf on 02/05/2022


import Foundation

class BackgroundFetchManager: NSObject{
    
    let headlinesManager = HeadlinesManager()
    let searchManager = SearchManager()
    let databaseManager = DatabaseManager()
    let deviceNotificationManager = DeviceNotificationManager()
        
    override init() {
        searchManager.fetchStoredKeywords()
        searchManager.sortStoredKeywords()
    }
    
    ///Fetches list of all searched keywords, requests newest headline for notifiable keyword.
    ///Compares stored titles with latest headline, and if latest title is different sends user notification
    func doBackgroundFetchForKeywords(){
        
        let searchedKeywords = searchManager.listOfSearchedKeywords
        for searchedKeyword in searchedKeywords {
            if searchedKeyword.notify{
                headlinesManager.fetchHeadlinesPerQuery(query: searchedKeyword.keyword) { [self] headlines in
                    let fetchedHeadlines = headlines
                    if let fetchedHeadlines = fetchedHeadlines {
                        if let latestHeadline = fetchedHeadlines.first{
                            if let title = latestHeadline.title {
                                do{
                                    let latestStoredHeadlines = try databaseManager.retrieve(tableName: .latestHeadlines)
                                    if let latestStoredHeadlines = latestStoredHeadlines {
                                        let filtered = latestStoredHeadlines.filter { $0[databaseManager.headlineTitle] == title}
                                        if !filtered.isEmpty{
                                            print("No need for action")
                                            if !latestStoredHeadlines.isEmpty{
                                                return
                                            }
                                        }
                                        guard let publishedAt = latestHeadline.publishedAt else{
                                            return
                                        }
                                        self.deviceNotificationManager.createNotification(keyword: searchedKeyword.keyword, headline: latestHeadline)
                                        try databaseManager.saveTo(tableName: .latestHeadlines, latestHeadline: LatestHeadline(headlineTitle: title, publishedAt: publishedAt))
                                    }
                                }catch(let error){
                                    print("Error", error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
