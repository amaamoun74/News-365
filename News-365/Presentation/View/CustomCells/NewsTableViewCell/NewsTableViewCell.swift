//
//  NewsTableViewCell.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsDescription: UILabel!
    @IBOutlet weak var lblNewsTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // lblNewsDescription.sizeToFit()
    }

    @IBAction func saveNewsBtn(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
