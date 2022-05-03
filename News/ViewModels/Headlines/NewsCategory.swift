//
//	NewsCategory
//  News
//	Created by: @nedimf on 30/04/2022


import Foundation

enum NewsCategory: String {
    case trending = "trending"
    case technology = "tech"
    case business = "business"
    case entertainment = "entertainment"
    case health = "health"
    case science = "science"
    case sports = "sports"
}

extension NewsCategory:CaseIterable, Identifiable {
    var id: Self { self }
}

