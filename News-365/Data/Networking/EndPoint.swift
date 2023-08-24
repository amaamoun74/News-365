//
//  EndPoint.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
import Alamofire

enum Endpoint {
    case searchNews(keyword: String)
    case topHeadlines(category: String, country: String)
    
    var path: String {
        switch self {
        case .searchNews:
            return "\(BASE_URL)everything"
        case .topHeadlines:
            return "\(BASE_URL)top-headlines"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchNews:
            return .get
        case .topHeadlines:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .searchNews(keyword: let keyword):
            return ["q": keyword, "apiKey": API_KEY]
        case .topHeadlines(category: let category, country: let country):
            return ["country": country, "category": category, "apiKey": API_KEY]
            //default: return nil
        }
    }
}

