//
//  ErrorHandler.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
enum ServiceError: Error {
    case networkFailure
    case ClinetError
    case ServerError
    case invalidResponse
    case decodingError
    case encodingError
    case customError(String)
}
