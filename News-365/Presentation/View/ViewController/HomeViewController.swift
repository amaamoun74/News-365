//
//  HomeViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var newsCategory: UICollectionView!
    private var remoteViewModel = RemoteNewsViewModel()
    private var tableDataSources : NewsDataSources?
    private var collectionDataSource : CategoryDataSource?
    private var categoryList: [Category]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryList = [Category(CategoryName: "general" , cattegoryImage: nil),
                        Category(CategoryName: "business" , cattegoryImage: "businessIcon"),
                        Category(CategoryName: "entertainment" , cattegoryImage: nil),
                        Category(CategoryName: "health" , cattegoryImage: nil),
                        Category(CategoryName: "science" , cattegoryImage: nil),
                        Category(CategoryName: "technology" , cattegoryImage: "techIcon"),
                        Category(CategoryName: "sports" , cattegoryImage: "sportIcon")]
        
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        requestNewsList()
        bindCategoriesToDataSource()
    }
    func registerCell(){
        newsTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        newsCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsCatgeogry")
    }
    func bindCategoriesToDataSource(){
        let categoryViewModel = CategorySectionViewModel(categoryList!)
        self.collectionDataSource = .init(categoryViewModel)
        self.newsCategory.delegate = collectionDataSource
        self.newsCategory.dataSource = collectionDataSource
        
        self.newsCategory.reloadData()
    }
}

/// request news and send result to data source for displying it
extension HomeViewController {
    func requestNewsList(){
        remoteViewModel.getNews(category: "general") { [unowned self] result in
            switch result {
            case .success(let response):
                print (response?.articles?.first?.title ?? "no data")
                bindNewsToDataSource(newsResponse: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func bindNewsToDataSource(newsResponse response: News?){
        let newsSectionViewModel = NewsSectionViewModel(response?.articles ?? [Article]())
        self.tableDataSources = .init(newsSectionViewModel)
        self.newsTable.delegate = tableDataSources
        self.newsTable.dataSource = tableDataSources
        self.newsTable.reloadData()
    }
}
