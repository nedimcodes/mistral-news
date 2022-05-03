//
//	HeadlinesManager
//  News
//	Created by: @nedimf on 29/04/2022


import Foundation
import Combine

class HeadlinesManager: ObservableObject{
    
    @Published var fetchedHeadlines: [Headline]?
    @Published var loadingAction = false
    @Published var errorLoading = false
    private var newsAPIHandler: NewsAPIHandler?
    
    typealias HeadlinesPerQueryResult = ([Headline]?)->()

    
    init(){
        newsAPIHandler = NewsAPIHandler()
    }
    
    ///Fetches top headlines for provided category
    ///Method is able to achieve pagination when page parameter is provided
    ///- Parameter category:NewsCategory? if not passed defaults to nil.
    ///- Parameter page:Int? if not passed defaults to nil.
    ///- Warning method updates to @Published
    func fetchHeadlines(category: NewsCategory?=nil, page: Int?=nil){
        self.fetchedHeadlines = nil
        self.loadingAction = true
        var endpoint = Endpoint().headlines(page: page)
        if let category = category {
            self.fetchedHeadlines = [Headline]()
            endpoint = Endpoint().headlines(query: category.rawValue, page: page)
        }
        if let newsAPIHandler = newsAPIHandler {
            
            newsAPIHandler.fetchNewsAPI(Response.self, endpoint: endpoint) { result in
                switch(result){
                case .success(let data):
                    DispatchQueue.main.async {
                        if data.status == "error"{
                            self.errorLoading = true
                        }
                        if let page = page {
                            if page > 0{
                                if let data = data.headlines{
                                    for headline in data{
                                        if let fetchedHeadlines = self.fetchedHeadlines {
                                            if !fetchedHeadlines.contains(where: {$0.title == headline.title }){
                                                self.fetchedHeadlines?.append(headline)
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            self.fetchedHeadlines = data.headlines
                        }
                        self.loadingAction = false
                    }
                case .failure(let error):
                    print(error)
                    self.errorLoading = true
                }
                
            }
        }
        
    }
    
    ///Fetches top headlines for provided category
    ///Method is able to achieve pagination when page parameter is provided
    ///- Parameter query:String? if not passed defaults to nil.
    ///- Parameter page:Int? if not passed defaults to nil.
    ///- Parameter complete:HeadlinesPerQueryResult? if not passed defaults to nil.
    ///- Warning: method updates to @Published
    ///
    ///complete closure is meant to be used when method is called outside SwiftUI state
    func fetchHeadlinesPerQuery(query: String, page: Int?=nil, complete: HeadlinesPerQueryResult?=nil){
        self.loadingAction = true
        let passingQuery = query.replacingOccurrences(of: " ", with: "+")
        let endpoint = Endpoint().headlines(query: passingQuery, page: page)
        if let newsAPIHandler = newsAPIHandler {
            
            newsAPIHandler.fetchNewsAPI(Response.self, endpoint: endpoint) { result in
                switch(result){
                case .success(let data):
                    DispatchQueue.main.async {
                        if data.status == "error"{
                            self.errorLoading = true
                        }
                        if let page = page {
                            if page > 0{
                                if let data = data.headlines{
                                    for headline in data{
                                        if let fetchedHeadlines = self.fetchedHeadlines {
                                            if !fetchedHeadlines.contains(where: {$0.title == headline.title }){
                                                self.fetchedHeadlines?.append(headline)
                                            }
                                        }
                                    }
                                    if let complete = complete {
                                        complete(self.fetchedHeadlines)
                                    }
                                }
                            }
                        }else{
                            self.fetchedHeadlines = data.headlines
                            if let complete = complete {
                                complete(data.headlines)
                            }
                        }
                        self.loadingAction = false
                    }
                case .failure(let error):
                    print(error)
                    self.errorLoading = true
                }
                
            }
        }
        
    }
}
