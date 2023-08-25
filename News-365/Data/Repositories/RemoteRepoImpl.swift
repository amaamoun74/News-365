//
//  RemoteRepoImpl.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
class RemoteRepoImpl: RemoteNewsRepoProtocol {
    
    
    let networkManger: NetworkManagerProtocol
    init(networkManger: NetworkManagerProtocol = NetworkManager()) {
        self.networkManger = networkManger
    }
    
    
    
    func getNews(endPoint: Endpoint, compiltion: @escaping (Result<News?, ServiceError>) -> Void) {
        networkManger.request(endpoint: endPoint, responseClass: News.self) { result in
            compiltion(result)
        }
    }
    
    func searchNews(keyword: String, compilition: @escaping (Result<News?, ServiceError>) -> Void) {
        networkManger.request(endpoint: .topHeadlines(category: "", country: ""), responseClass: News.self) { result in
            compilition(result)
        }
        
    }
}
