//
//  RemoteUseCase.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
class RemoteUseCase {
    // init DI
    private let repo: RemoteNewsRepoProtocol
    init(repo: RemoteNewsRepoProtocol = RemoteRepoImpl()) {
        self.repo = repo
    }
    
    func getNews(category: String, country: String, compiltion: @escaping (Result<News?, ServiceError>) -> Void){
        var topHeadlines: Endpoint = .topHeadlines(category: category, country: country)
        repo.getNews(endPoint: topHeadlines) { result in
            compiltion(result)
        }
    }
    
    func searchNews(keyword: String, compilition: @escaping (Result<News, ServiceError>) -> Void){
        
    }
}
