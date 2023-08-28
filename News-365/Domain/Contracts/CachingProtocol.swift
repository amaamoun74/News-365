//
//  CachingProtocol.swift
//  News-365
//
//  Created by ahmed on 28/08/2023.
//

import Foundation
protocol CachingProtocol {
    func saveArticleToFavourite(article: Article)
    func deleteArticleFromFavourtie(title: String)
    func isArticleSaved(title: String) -> Bool
}
