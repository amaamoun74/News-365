//
//  NewsTableViewCell.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsDescription: UILabel!
    @IBOutlet weak var lblNewsTitle: UILabel!
    private var ViewModel: LocalNewsViewModel?
    var artical: Article?
    var caching: CachingProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ViewModel = LocalNewsViewModel()
        configureView()
    }
    
    @IBAction func saveNewsBtn(_ sender: Any) {
        if caching?.isArticleSaved(title: artical?.title ?? "XYZ" ) == true {
            caching?.deleteArticleFromFavourtie(title: artical?.title ?? "XYZ")
            btnSave.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        else {
            dump(artical)
            caching?.saveArticleToFavourite(article: artical!)
            btnSave.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //ViewModel!.saveArticalToFavourite(appDelegate: appDelegate, articale: artical!)
        // Configure the view for the selected state
    }
}
extension NewsTableViewCell {
    private func configureView(){
        lblNewsDescription.sizeToFit()
        btnSave.layer.borderColor =  UIColor.black.cgColor
        btnSave.layer.borderWidth = 1.5
        btnSave.layer.cornerRadius = 10
    }
}
