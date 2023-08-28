//
//  LocalUseCase.swift
//  News-365
//
//  Created by ahmed on 28/08/2023.
//

import Foundation
class LocalUseCase {
    
    // init DI
    private let repo: LocalNewsRepoProtocol
    init(repo: LocalNewsRepoProtocol = LocalRepoImpl()) {
        self.repo = repo
    }
    
    func fetchSavedNews(appDelegate: AppDelegate, complition: ([Article]) -> Void) {
        repo.fetchSavedNews(appDelegate: appDelegate) { articals in
            complition(articals)
        }
    }
    
    func fetchByTitle(appDelegate: AppDelegate, searchTitle: String, complition: ([Article]) -> Void) {
        repo.fetchByTitle(appDelegate: appDelegate, searchTitle: searchTitle) { Articles in
            complition(Articles)
        }
    }
    
    func saveArticalToFavourites(appDelegate: AppDelegate, articale: Article) {
        repo.saveArticalToFavourites(appDelegate: appDelegate, articale: articale)
    }
    
    func isSavedArticale(appDelegate: AppDelegate, articaleTitle: String) -> Bool {
        repo.isSavedArticale(appDelegate: appDelegate, articaleTitle: articaleTitle)
    }
    
    func delete(appDelegate: AppDelegate, title: String, complition: (Error?) -> Void) {
        repo.delete(appDelegate: appDelegate, title: title) { error in
            complition(error)
        }
    }
}
