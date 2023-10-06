//
//  RemoteUseCase.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Combine

protocol RemoteUseCaseProtocol {
    func getNews(category: String, country: String) -> AnyPublisher<News, NetworkError>
}

class RemoteUseCase: RemoteUseCaseProtocol {
    // init DI
    private let repo: RemoteNewsRepoProtocol
    init(repo: RemoteNewsRepoProtocol = RemoteRepoImpl()) {
        self.repo = repo
    }
    
    func getNews(category: String, country: String, compiltion: @escaping (Result<News?, NetworkError>) -> Void){
        let topHeadlines: Endpoint = .topHeadlines(category: category, country: country)
        repo.getNews(endPoint: topHeadlines) { result in
            compiltion(result)
        }
    }
    
    func searchNews(keyword: String, compilition: @escaping (Result<News?, NetworkError>) -> Void){
        // let search: Endpoint = .searchNews(keyword: keyword)
        repo.searchNews(keyword: keyword) { result in
            compilition(result)
        }
    }
    func getNews(category: String, country: String) -> AnyPublisher<News, NetworkError> {
        let topHeadlines: Endpoint = .topHeadlines(category: category, country: country)
        return repo.getNews(endPoint: topHeadlines)
    }
}
