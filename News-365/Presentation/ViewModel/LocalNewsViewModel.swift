//
//  LocalNewsViewModel.swift
//  News-365
//
//  Created by ahmed on 28/08/2023.
//

import Foundation
class LocalNewsViewModel {
    private let localUseCase = LocalUseCase()
    /*var bindingNews : ((News?, ServiceError)->()) = {_,_ in }
     var newsResponse : News?{
     didSet{
     bindingNews()
     }*/
    
    func fetchNews(appDelegate: AppDelegate, complition: ([Article]) -> Void) {
        localUseCase.fetchSavedNews(appDelegate: appDelegate) { articals in
            complition(articals)
        }
    }
    
    func fetchNewsByTitle(appDelegate: AppDelegate, searchTitle: String, complition: ([Article]) -> Void) {
        localUseCase.fetchByTitle(appDelegate: appDelegate, searchTitle: searchTitle) { articals in
            complition(articals)
        }
    }
    
    func saveArticalToFavourite(appDelegate: AppDelegate, articale: Article) {
        localUseCase.saveArticalToFavourites(appDelegate: appDelegate, articale: articale)
    }
    
    func isSavedArticale(appDelegate: AppDelegate, articaleTitle: String) -> Bool {
        return localUseCase.isSavedArticale(appDelegate: appDelegate, articaleTitle: articaleTitle)
    }
    
    func deleteNewsFromFavourite(appDelegate: AppDelegate, title: String, complition: (Error?) -> Void) {
        localUseCase.delete(appDelegate: appDelegate, title: title) { error in
            complition(error)
        }
    }
}
