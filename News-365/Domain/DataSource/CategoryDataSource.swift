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
    var categorySelection: ICategorySelection?
    private var selectedIndex: Int = 0
    private var lastInactiveIndex: IndexPath = [1 ,0]
    init(_ categoryViewModel: CategorySectionViewModel){
        self.categoryViewModel = categoryViewModel
    }
}
extension CategoryDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        {
           if cell.isSelected {
                cell.configureSelectedView()
               cell.isSelected = true
            }
            else {
                cell.configureUnselectedView()
            }
            
        }
    }
     func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //selectedIndex = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        {
            cell.configureUnselectedView()
            cell.isSelected = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        {
            cell.stackView.backgroundColor = .systemGray
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
        {
            cell.stackView.backgroundColor = nil
        }
    }
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
        cell.stackView.layer.borderColor = selectedIndex == indexPath.row ? UIColor(named: "thirdRed")?.cgColor : UIColor(named: "secondRed")?.cgColor
        if cell.isSelected {
            cell.configureSelectedView()
        }
        else {
            cell.configureUnselectedView()
        }
        return cell
    }
}

extension CategoryDataSource : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.35, height: collectionView.frame.height*0.9)
    }
    
}
