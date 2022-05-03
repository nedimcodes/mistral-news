//
//	NavigationHistory
//  News
//	Created by: @nedimf on 01/05/2022


import Foundation

struct NavigationHistory{
    let screen: NavigationScreens
    let id: UUID
    let category: NewsCategory?
    let headlines: [Headline]?
}
