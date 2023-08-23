//
//  News.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
struct News: Codable{
    var status: String?
    var totalResults: Int?
    var articles : [Article]?
}
