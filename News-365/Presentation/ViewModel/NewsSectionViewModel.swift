//
//  NewsSectionViewModel.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import Foundation
class NewsSectionViewModel{
    var dataSource: [Article]
    init(_ dataSource: [Article]) {
        self.dataSource = dataSource
    }
}
