//
//  NetworkService.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Alamofire
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(endpoint: Endpoint, responseClass: T.Type, completion: @escaping (Result<T?, ServiceError>) -> Void) {
        guard let url = URL(string: endpoint.path) else {
            completion(.failure(.networkFailure))
            return
        }
        
        AF.request(url,
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   headers: endpoint.headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 400...499:
                        completion(.failure(.ClinetError))
                    case 500...599:
                        completion(.failure(.ServerError))
                    default:
                        completion(.failure(.invalidResponse))
                    }
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
}
