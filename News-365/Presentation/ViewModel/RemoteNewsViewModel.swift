//
//  RemoteNewsViewModel.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation

class RemoteNewsViewModel{
    let remoteUseCase = RemoteUseCase()
    /*var bindingNews : ((News?, ServiceError)->()) = {_,_ in }
     var newsResponse : News?{
     didSet{
     bindingNews()
     }*/
    
    func getNews(category: String, complition: @escaping(Result<News? , ServiceError>) -> Void){
        let country = UserDefaults.standard.value(forKey: Constants.shared.COUNTRYCODE) as? String ?? "EG"
        remoteUseCase.getNews(category: category, country: country) { result in
            complition(result)
        }
    }
    func searchForNews(titleKeyword: String , complition: @escaping(Result<News? , ServiceError>) -> Void){
        remoteUseCase.searchNews(keyword: titleKeyword) { result in
            complition(result)
        }
    }
}
