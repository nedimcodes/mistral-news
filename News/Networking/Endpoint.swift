//
//	Endpoint
//  News
//	Created by: @nedimf on 29/04/2022


import Foundation

///Endpoint to simplify building queried URL
struct Endpoint {
    var path: String?=nil
    var queryItems: [URLQueryItem]?=nil
    
    var URL: URL?{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        if let path = path {
            components.path = path
        }
        components.queryItems = queryItems
        
        return components.url
    }
    
}

extension Endpoint {
    ///Endpoint configured for `/everything` and `/top-headlines` routes
    ///- Parameter query:String, defaults to nil if not passed
    ///- Parameter page:Int, defaults to nil if not passed
    ///- Returns: Endpoint
    func headlines(query: String?=nil, page: Int?=nil) -> Endpoint {
        var queryEverythingItems = [URLQueryItem(name: "q", value: query)]
        var queryTopHeadlinesItems = [URLQueryItem(name: "country", value: "us")]

        if let page = page {
            queryEverythingItems.append(URLQueryItem(name: "page", value: String(page)))
            queryTopHeadlinesItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        
        if let query = query {
            queryEverythingItems.append(URLQueryItem(name: "q", value: query))
            return Endpoint(
                path: "/v2/everything",
                queryItems: queryEverythingItems
            )
        }
        return Endpoint(
            path: "/v2/top-headlines",
            queryItems: queryTopHeadlinesItems
        )
    }
}

