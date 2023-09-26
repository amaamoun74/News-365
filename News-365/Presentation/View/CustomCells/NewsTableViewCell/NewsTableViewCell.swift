//
//  NewsTableViewCell.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit
import TTGSnackbar

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
        
        if let title = artical?.title {
            if caching?.isArticleSaved(title: title) == true {
                caching?.deleteArticleFromFavourtie(title: title)
                btnSave.setImage(UIImage(systemName: "bookmark"), for: .normal)
                let msg = "\(title) was deleted successfully"
                DispatchQueue.main.async {
                    self.showSnakbar(msg: msg)
                }
            }
            else {
                dump(artical)
                caching?.saveArticleToFavourite(article: artical!)
                btnSave.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                let msg = "\(title) was added successfully"
                DispatchQueue.main.async {
                    self.showSnakbar(msg: msg)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension NewsTableViewCell {
    private func configureView(){
        lblNewsDescription.sizeToFit()
        btnSave.layer.borderColor =  UIColor(named: "secondRed")?.cgColor
        btnSave.layer.borderWidth = 1.5
        btnSave.layer.cornerRadius = 10
        imgNews.layer.borderWidth = 0.5
        imgNews.layer.borderColor =  UIColor(named: "secondRed")?.cgColor
        imgNews.layer.cornerRadius = 5
    }
    private func showSnakbar(msg: String)
    {
        let snackbar = TTGSnackbar(
            message: msg,
            duration: .middle
            )
        
        snackbar.backgroundColor = .systemGreen
        snackbar.messageTextColor = .systemBackground
        snackbar.show()
    }
}

