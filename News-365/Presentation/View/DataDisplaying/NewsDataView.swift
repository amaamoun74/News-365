//
//  NewsDataViewViewController.swift
//  News-365
//
//  Created by ahmed on 25/09/2023.
//

import UIKit

class NewsDataView: UIView {

    @IBOutlet weak var tableNews: UITableView!
    @IBOutlet weak var newsLbl: UILabel!
    //var delegate
    override public func awakeFromNib() {
        super.awakeFromNib()
        tableNews.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        newsLbl.text = NSLocalizedString("news", comment: "")
    }
}
