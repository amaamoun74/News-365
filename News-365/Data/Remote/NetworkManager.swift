//
//  NetworkService.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Alamofire
import Combine
protocol NetworkManagerProtocol {
    func request<T: Decodable>(endpoint: Endpoint, responseClass: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void)
    
    func requestData<T: Decodable>(from endpoint: Endpoint, responseClass: T.Type) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
    
    func request<T: Decodable>(endpoint: Endpoint, responseClass: T.Type, completion: @escaping (Result<T?, NetworkError>) -> Void) {
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
                        completion(.failure(.clientError(statusCode: statusCode)))
                    case 500...599:
                        completion(.failure(.serverError(statusCode: statusCode)))
                    default:
                        completion(.failure(.invalidResponse))
                    }
                } else {
                    completion(.failure(.networkFailure))
                }
            }
        }
    }
    
    func requestData<T: Decodable>(from endpoint: Endpoint, responseClass: T.Type) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { promise in
            guard let url = URL(string: endpoint.path) else {
                promise(.failure(.invalidResponse))
                return
            }
            AF.request(url,
                       method: endpoint.method,
                       parameters: endpoint.parameters,
                       headers: endpoint.headers).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(_):
                    if let statusCode = response.response?.statusCode {
                        let networkError = NetworkError(statusCode: statusCode)
                        promise(.failure(networkError))
                    } else {
                        promise(.failure(NetworkError.networkFailure))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
