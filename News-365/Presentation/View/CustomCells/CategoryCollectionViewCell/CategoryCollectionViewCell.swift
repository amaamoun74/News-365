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
        configureView()
        // Initialization code
    }
    private func configureView(){
        stackView.layer.borderColor =  UIColor(named: "secondRed")?.cgColor
        stackView.layer.borderWidth = 1.5
        stackView.layer.cornerRadius = 10
    }
}
