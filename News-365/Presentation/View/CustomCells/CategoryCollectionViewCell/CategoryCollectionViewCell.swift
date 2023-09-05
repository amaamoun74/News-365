//
//  CategoryCollectionViewCell.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // configureUnselectedView()
        // Initialization code
    }
    func configureUnselectedView(){
        contentView.layer.borderColor =  UIColor(named: "thirdRed")?.cgColor
        contentView.layer.borderWidth = 1.5
        contentView.layer.cornerRadius = 10
    }
    func configureSelectedView(){
        print("AHMED")
        contentView.layer.borderColor =  UIColor(named: "secondRed")?.cgColor
        contentView.layer.borderWidth = 1.5
        contentView.layer.cornerRadius = 10
    }
}
