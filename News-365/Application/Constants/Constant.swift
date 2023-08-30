//
//  Constant.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation

public let BASE_URL = "https://newsapi.org/v2/"
public var API_KEY: String  {
    Bundle.main.infoDictionary!["APIKey"] as! String
}
public let ENTITY_NAME = "Artical_Entity"
public let APPLE_LANGUAGES = "AppleLanguages"
