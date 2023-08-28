//
//  LocalNewsRepoImpl.swift
//  News-365
//
//  Created by ahmed on 28/08/2023.
//

import Foundation
class LocalRepoImpl: LocalNewsRepoProtocol {
    
    let localDataManager: IDataManager
    init(localDataManager: IDataManager = LocalDataManager()) {
        self.localDataManager = localDataManager
    }
    
    func fetchSavedNews(appDelegate: AppDelegate, complition: ([Article]) -> Void) {
        let result = localDataManager.fetch(searchedTitle: "", appDelegate: appDelegate)
        complition(result)
    }
    
    func fetchByTitle(appDelegate: AppDelegate, searchTitle: String, complition: ([Article]) -> Void) {
        let result = localDataManager.fetch(searchedTitle: searchTitle, appDelegate: appDelegate)
        complition(result)
    }
    
    func saveArticalToFavourites(appDelegate: AppDelegate, articale: Article) {
        localDataManager.save(articale: articale, appDelegate: appDelegate)
    }
    
    func isSavedArticale(appDelegate: AppDelegate, articaleTitle: String) -> Bool{
        return localDataManager.isSaved(articalTitle: articaleTitle, appDelegate: appDelegate)
    }
    
    func delete(appDelegate: AppDelegate, title: String, complition: (Error?) -> Void) {
        localDataManager.delete(appDelegate: appDelegate, title: title) { error in
            complition(error)
        }
    }
}
