//
//  NewsDataSource.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//
import UIKit
import Kingfisher
class NewsDataSources: NSObject, UITableViewDelegate , UITableViewDataSource {
    private var postViewModel: NewsSectionViewModel
    
    init(_ postViewModel: NewsSectionViewModel){
        self.postViewModel = postViewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        let newsItem = postViewModel.dataSource[indexPath.row]
        cell.lblNewsTitle.text = newsItem.title
        cell.lblNewsDescription.text = newsItem.url
        let img = URL(string:newsItem.url ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.imgNews.kf.setImage(with:img)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
