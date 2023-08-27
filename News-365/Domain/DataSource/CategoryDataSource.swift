//
//  CategoryDataSource.swift
//  News-365
//
//  Created by ahmed on 27/08/2023.
//

import Foundation
import UIKit
class CategoryDataSource: NSObject {
    private var categoryViewModel: CategorySectionViewModel
    
    init(_ categoryViewModel: CategorySectionViewModel){
        self.categoryViewModel = categoryViewModel
    }
}
extension CategoryDataSource: UICollectionViewDelegate {
   
}

extension CategoryDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel.dataSource.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCatgeogry", for: indexPath) as! CategoryCollectionViewCell
        let category = categoryViewModel.dataSource[indexPath.row]
        cell.lblCategoryName.text = category.CategoryName
        cell.categoryImg.image = UIImage(named: category.cattegoryImage ?? "sportIcon")
        return cell
    }
}

extension CategoryDataSource : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.35, height: collectionView.frame.height*0.9)
    }
    
}
