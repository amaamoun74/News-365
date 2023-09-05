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
    private var localNewsViewModel = LocalNewsViewModel()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var render: IRenderView?

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
        cell.lblNewsDescription.text = newsItem.description
        let img = URL(string:newsItem.urlToImage ?? "https://apiv2.allsportsapi.com//logo//players//100288_diego-bri.jpg")
        cell.imgNews.kf.setImage(with:img)
        cell.caching = self
        cell.artical = newsItem
        if localNewsViewModel.isSavedArticale(appDelegate: appDelegate, articaleTitle: newsItem.title ?? "") == true {
            cell.btnSave.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        }else{
            cell.btnSave.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
        dump(cell.artical ?? Article())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension NewsDataSources: CachingProtocol{
    func saveArticleToFavourite(article: Article) {
        localNewsViewModel.saveArticalToFavourite(appDelegate: appDelegate, articale: article)
        render?.reload()
    }
    
    func deleteArticleFromFavourtie(title: String) {
        localNewsViewModel.deleteNewsFromFavourite(appDelegate: appDelegate, title: title) { error in
            print(error?.localizedDescription ?? "")
            render?.reload()
        }
    }
    
    func isArticleSaved(title: String) -> Bool  {
        return localNewsViewModel.isSavedArticale(appDelegate: appDelegate , articaleTitle: title)
    }
}
