//
//  HomeViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    //@IBOutlet weak var newsTable: UITableView!
    // @IBOutlet weak var newsCategory: UICollectionView!
    private var remoteViewModel = RemoteNewsViewModel()
    private var dataSources : NewsDataSources?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        request()
    }
    
    func registerCell(){
        newsTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    
    func request(){
        remoteViewModel.getNews(category: "general") { [unowned self] result in
            switch result {
            case .success(let response):
                print (response?.articles?.first?.title ?? "no data")
                let newsSectionViewModel = NewsSectionViewModel(response?.articles ?? [Article]())
                self.dataSources = .init(newsSectionViewModel)
                self.newsTable.delegate = dataSources
                self.newsTable.dataSource = dataSources
                self.newsTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
