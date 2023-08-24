//
//  HomeRepoProtocol.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
protocol RemoteNewsRepoProtocol {
    func getNews(endPoint: Endpoint, compiltion: @escaping (Result<News?, ServiceError>) -> Void)
    func searchNews(keyword: String, compilition: @escaping (Result<News?, ServiceError>) -> Void)
}
