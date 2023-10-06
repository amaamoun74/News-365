//
//  RemoteRepoImpl.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Combine
class RemoteRepoImpl: RemoteNewsRepoProtocol {
    private let networkManger: NetworkManagerProtocol
    init(networkManger: NetworkManagerProtocol = NetworkManager()) {
        self.networkManger = networkManger
    }
    
    
    
    func getNews(endPoint: Endpoint, compiltion: @escaping (Result<News?, NetworkError>) -> Void) {
        networkManger.request(endpoint: endPoint, responseClass: News.self) { result in
            compiltion(result)
        }
    }
    
    func searchNews(keyword: String, compilition: @escaping (Result<News?, NetworkError>) -> Void) {
        networkManger.request(endpoint: .searchNews(keyword: keyword), responseClass: News.self) { result in
            compilition(result)
        }
    }
    
    func getNews(endPoint: Endpoint) -> AnyPublisher<News, NetworkError> {
        return networkManger.requestData(from: endPoint, responseClass: News.self)
    }
    
}
