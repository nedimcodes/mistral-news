//
//	NavigationManager
//  ObservableObject managing navigation history state
//  News
//	Created by: @nedimf on 01/05/2022


import Foundation


enum NavigationScreens{
    case headlines
    case search
}

///Managing navigation history state
class NavigationManager: ObservableObject{
    @Published var listNavigationHistory =  [NavigationHistory]()
    
    ///Pushes new NavigationHistory to stack
    ///- Parameter history:NavigationHistory
    func pushHistoryState(history: NavigationHistory){
        self.listNavigationHistory.append(history)
    }
    
    ///Returns most recent NavigationHistory from stack
    ///- Returns: NavigationHistory?
    func mostRecentHistoryState() -> NavigationHistory?{
        return self.listNavigationHistory.last
    }
}
