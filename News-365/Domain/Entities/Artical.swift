//
//  Artical.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
struct Article :Codable {
    
    var source: Source?
    var author : String?
    var title : String?
    var description : String?
    var url: String?
    var urlToImage : String?
    var publishedAt : String?
    var content: String?
}
