//
//  LocalNewsRepoProtocol.swift
//  News-365
//
//  Created by ahmed on 28/08/2023.
//

import Foundation
protocol LocalNewsRepoProtocol {
    func fetchSavedNews(appDelegate: AppDelegate , complition: ([Article]) -> Void)
    
    func fetchByTitle(appDelegate: AppDelegate, searchTitle: String , complition: ([Article]) -> Void )
    
    func saveArticalToFavourites(appDelegate: AppDelegate, articale: Article)
    
    func isSavedArticale(appDelegate: AppDelegate, articaleTitle: String) -> Bool
    
    func delete(appDelegate: AppDelegate, title: String, complition : (Error?) -> Void)
}
