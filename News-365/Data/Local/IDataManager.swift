//
//  IDataManager.swift
//  News-365
//
//  Created by ahmed on 27/08/2023.
//

import Foundation
protocol IDataManager {
    func fetch(searchedTitle: String, appDelegate : AppDelegate) -> [Article]
    
    func delete(appDelegate: AppDelegate, title: String , complition : (Error?) -> Void)
    
    func save(articale : Article, appDelegate : AppDelegate) -> Void
    
    func isSaved(articalTitle: String, appDelegate : AppDelegate) -> Bool
}
