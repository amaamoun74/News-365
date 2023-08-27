//
//  CategorySectionViewModel.swift
//  News-365
//
//  Created by ahmed on 27/08/2023.
//

import Foundation
class CategorySectionViewModel {
    var dataSource: [Category]
    init(_ dataSource: [Category]) {
        self.dataSource = dataSource
    }
}
