//
//  NewsDataSource.swift
//  News-365
//
//  Created by ahmed on 24/08/2023.
//

import UIKit
class NewsDataSources: NSObject , UITableViewDelegate , UITableViewDataSource {
    private var postViewModel: NewsSectionViewModel
    
    init(_ postViewModel: NewsSectionViewModel){
        self.postViewModel = postViewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postViewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.lblBody.text = postViewModel.dataSource[indexPath.item].description
        cell.lblTitle.text = postViewModel.dataSource[indexPath.item].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
