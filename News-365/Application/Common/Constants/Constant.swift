//
//  Constant.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation

class Constants {
    
    static let shared = Constants()
    private init() {}
    
    let BASE_URL: String = "https://newsapi.org/v2/"
    var API_KEY: String  {
        Bundle.main.infoDictionary!["APIKey"] as! String
    }
    let ENTITY_NAME = "Artical_Entity"
    let APPLE_LANGUAGES = "AppleLanguages"
    let SELECTED_THEME = "selectedTheme"
}
