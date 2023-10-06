//
//  ErrorHandler.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
enum NetworkError: Error {
    case networkFailure
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case invalidResponse
    case decodingError
    case encodingError
    case customError(String)

    init(statusCode: Int) {
           switch statusCode {
           case 400...499:
               self = .clientError(statusCode: statusCode)
           case 500...599:
               self = .serverError(statusCode: statusCode)
           default:
               self = .customError("Unkown Error")
           }
       }
}
