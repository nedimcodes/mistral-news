//
//	SearchManager
//  ObservableObject Managing keywords search
//  News
//	Created by: @nedimf on 29/04/2022


import Foundation
import SQLite
import SwiftUI

///Managing keywords search
class SearchManager: ObservableObject{
    
    @Published var listOfSearchedKeywords = [Search]()
    @Published var searchKeyword = ""
    @Published var hideSticky = true

    let databaseManager = DatabaseManager()
    
    ///Stores search keyword and assigns it notified state based on provided parameter.
    ///- Parameter notify:Bool? if not passed defaults to nil.
    ///- Warning: method updates to @Published
    func storeSearchKeyword(notify: Bool?=nil){
        if !searchKeyword.isEmpty{
            do {
                let dbKeywords = try databaseManager.retrieve(tableName: .searchKeywords)
                if let dbKeywords = dbKeywords {
                    if !dbKeywords.contains(where: {$0[databaseManager.keyword] == searchKeyword }){
                        try self.databaseManager.saveTo(tableName: .searchKeywords, search: Search(keyword: searchKeyword))
                    }else{
                        if let notify = notify {
                            try self.databaseManager.deleteRow(tableName: .searchKeywords, value: searchKeyword)
                            try self.databaseManager.saveTo(tableName: .searchKeywords, search: Search(keyword: searchKeyword, notify: notify))
                        }
                    }
                }
            }catch(let err){
                print("Failed: \(err)")
            }
        }
    }
    
    ///Fetched stored keywords
    ///- Warning: method updates to @Published
    func fetchStoredKeywords(){
        self.listOfSearchedKeywords = [Search]()
        do{
            let dbKeywords = try databaseManager.retrieve(tableName: .searchKeywords)
            if let dbKeywords = dbKeywords {
                for dbKeyword in dbKeywords {
                    listOfSearchedKeywords.append(Search(id: dbKeyword[databaseManager.id], keyword: dbKeyword[databaseManager.keyword], notify: dbKeyword[databaseManager.notify]))
                }
            }
        }catch(let err){
            print("Failed: \(err)")
        }
    }
    
    ///Deletes stored keyword
    ///- Parameter keyword:String pass keyword value you wish to delete
    func deleteStoredKeyword(for keyword: String){
        do{
            try databaseManager.deleteRow(tableName: .searchKeywords, value: keyword)
        }catch(let err){
            print("Failed: \(err)")
        }
    }
    
    ///Sorts contents of searched keywords list
    ///- Warning: method sorts alphabetically
    func sortStoredKeywords(){
        self.listOfSearchedKeywords = listOfSearchedKeywords.sorted(by: { $0.keyword < $1.keyword })
    }
    
}
