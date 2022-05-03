//
//	DatabaseManager
//  NSObject managing local SQLite database
//  News
//	Created by: @nedimf on 01/05/2022


import Foundation
import SQLite

class DatabaseManager: NSObject{
    
    var DB: Connection?=nil
    let id = Expression<UUID>("id")
    let keyword = Expression<String>("keyword")
    let notify = Expression<Bool>("notify")
    
    let headlineTitle = Expression<String>("headlineTitle")
    let publishedAt = Expression<String>("publishedAt")
    
    override init() {
        super.init()
        do{
            try initDatabase()
        }catch{
            print(error)
        }
    }
    
    enum Tables: String{
        case searchKeywords = "search_keywords"
        case latestHeadlines = "latest_headlines"
    }
    
    ///Initialise new database and creates scheme for each defined table
    private func initDatabase() throws{
        
        let databaseFileName = "news.sqlite3"
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(databaseFileName)"
        #if DEBUG
        print(databaseFilePath)
        #endif
        DB = try Connection(databaseFilePath)
        
        let searchKeywordsTable = Table(Tables.searchKeywords.rawValue)
        let latestHeadlines = Table(Tables.latestHeadlines.rawValue)
        
        if let DB = DB {
            try DB.run(searchKeywordsTable.create(ifNotExists: true) { t in
                
                t.column(id, primaryKey: true)
                t.column(keyword)
                t.column(notify)
            })
            
            try DB.run(latestHeadlines.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(headlineTitle)
                t.column(publishedAt)
            })
        }
    }
    
    ///Saves row to provided table
    ///- Parameter tableName: Tables already defined table names.
    ///- Parameter search:Search pass if new Search object has to be stored.
    ///- Parameter latestHeadline:LatestHeadline pass if new LatestHeadline object has to be stored.
    ///- Warning: The methods throws.
    func saveTo(tableName: Tables, search: Search?=nil, latestHeadline: LatestHeadline?=nil) throws{
        let table = Table(tableName.rawValue)
        guard let DB = DB else {
            return
        }
        
        if let search = search {
            let insert = table.insert(
                id <- search.id,
                keyword <- search.keyword,
                notify <- search.notify
            )
            
            let rowId = try DB.run(insert)
            print("Saved to cache \(rowId)")
        }
        
        if let latestHeadline = latestHeadline {
            let insert = table.insert(
                id <- UUID(),
                headlineTitle <- latestHeadline.headlineTitle,
                publishedAt <- latestHeadline.publishedAt
            )
            
            let rowId = try DB.run(insert)
            print("Saved to cache \(rowId)")
        }
       
    }
    
    ///Retrieves single Row
    ///- Parameter tableName: Tables already defined table names.
    ///- Returns: [Row].
    ///- Warning: The methods throws.
    func retrieve(tableName: Tables) throws -> [Row]?{
        
        let table = Table(tableName.rawValue)
        var row = [Row]()
        guard let DB = DB else {
            return nil
        }
        
        for t in try DB.prepare(table){
            print(t)
            row.append(t)
        }
        
        return row
    }
    
    ///Deletes filtered Row
    ///- Parameter tableName: Tables already defined table names.
    ///- Parameter value:String? pass to filter table data by `keyword` column.
    ///- Parameter UUID:UUID? pass to filter table data by `id` column.
    ///- Warning: The methods throws.
    func deleteRow(tableName: Tables, value: String?=nil, UUID: UUID?=nil) throws{
        
        let table = Table(tableName.rawValue)
        guard let DB = DB else {
            return
        }
        
        if let UUID = UUID {
            let tableRow = table.filter(id == UUID)
            try DB.run(tableRow.delete())
        }
        
        if let value = value {
            let tableRow = table.filter(keyword == value)
            try DB.run(tableRow.delete())
        }
    }
}
