//
//  HomeRepoProtocol.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Combine

protocol RemoteNewsRepoProtocol {
    func getNews(endPoint: Endpoint, compiltion: @escaping (Result<News?, NetworkError>) -> Void)
    func searchNews(keyword: String, compilition: @escaping (Result<News?, NetworkError>) -> Void)
    func getNews(endPoint: Endpoint) -> AnyPublisher<News, NetworkError>

}
