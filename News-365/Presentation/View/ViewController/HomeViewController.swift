//
//  HomeViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var imgError: UIImageView!
    @IBOutlet weak var searchControler: UISearchBar!
    @IBOutlet weak var lblNews: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var newsTable: UITableView!
    @IBOutlet weak var newsCategory: UICollectionView!
    private var remoteViewModel = RemoteNewsViewModel()
    private var tableDataSources : NewsDataSources?
    private var collectionDataSource : CategoryDataSource?
    private var categoryList: [Category]?
    private let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchControler.delegate = self
        categoryList = [Category(CategoryName: "general" , cattegoryImage: nil),
                        Category(CategoryName: "business" , cattegoryImage: "businessIcon"),
                        Category(CategoryName: "entertainment" , cattegoryImage: nil),
                        Category(CategoryName: "health" , cattegoryImage: nil),
                        Category(CategoryName: "science" , cattegoryImage: nil),
                        Category(CategoryName: "technology" , cattegoryImage: "techIcon"),
                        Category(CategoryName: "sports" , cattegoryImage: "sportIcon")]
        configureViewsForLocalization()
        setRefreshController()
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
        collectionDataSource?.categorySelection = self
        self.newsCategory.delegate = collectionDataSource
        self.newsCategory.dataSource = collectionDataSource
        
        self.newsCategory.reloadData()
    }
}

/// request news and send result to data source for displying it
extension HomeViewController {
    @objc func requestNewsList(category: String = "general"){
        newsTable.isHidden = false
        remoteViewModel.getNews(category: category) { [unowned self] result in
            switch result {
            case .success(let response):
                refreshController.endRefreshing()
                print (response?.articles?.first?.title ?? "no data")
                bindNewsToDataSource(newsResponse: response)
            case .failure(let error):
                handleError(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    func bindNewsToDataSource(newsResponse response: News?){
        let newsSectionViewModel = NewsSectionViewModel(response?.articles ?? [Article]())
        self.tableDataSources = .init(newsSectionViewModel)
        self.tableDataSources?.navigationProtocol = self
        self.newsTable.delegate = tableDataSources
        self.newsTable.dataSource = tableDataSources
        self.newsTable.reloadData()
    }
    
    func setRefreshController(){
        refreshController.tintColor = .black
        refreshController.addTarget(self, action: #selector(requestNewsList), for: .valueChanged)
        newsTable.addSubview(refreshController)
    }
}
// configure view items for localization
extension HomeViewController {
    private func configureViewsForLocalization(){
        lblNews.text = NSLocalizedString("news", comment: "")
        lblCategory.text = NSLocalizedString("category", comment: "")
        homeTabBarItem.title = NSLocalizedString("home_title", comment: "") 
        searchBar.placeholder = NSLocalizedString("search_hint", comment: "") 
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            print(searchText)
            remoteViewModel.searchForNews(titleKeyword: searchText) { [unowned self] result in
                switch result {
                case .success(let response):
                    refreshController.endRefreshing()
                    print (response?.articles?.first?.title ?? "no data")
                    bindNewsToDataSource(newsResponse: response)
                case .failure(let error):
                    refreshController.endRefreshing()
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension HomeViewController: ICategorySelection {
    func getNewsWithCategory(categoryType: String) {
        print("maamoun")
        self.newsTable.reloadData()
        self.setRefreshController()
        self.requestNewsList(category: categoryType)
    }
    
    func handleError(error: ServiceError) {
        refreshController.endRefreshing()
       // newsTable.isHidden = true
        switch (error) {
        case .networkFailure:
            lblError.text = "No internet connection"
            print("No internet connection")
        case .ClinetError:
            lblError.text = "Bad request.. please try agian"
            print("Bad request.. please try agian")
        case .ServerError:
            lblError.text = "Server error.. please try again later"
            print("Server error.. please try again later")
        case .invalidResponse:
            lblError.text = "Bad response"
            print("Bad response")
        case .decodingError:
            lblError.text = "Error while getting response from the server"
            print("Error while getting response from the server")
        case .encodingError:
            lblError.text = "Error while sending requset to server"
            print("Error while sending requset to server")
        case .customError(_):
            lblError.text = "invaild action"
            print("invaild action")
        }
    }
    
}
extension HomeViewController: NavigationProtocol {
    func navigateToWebView(articalURL: String?) {
        if let url = articalURL {
            let webVC = self.storyboard!.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
            webVC.articaleURL = url
            self.present(webVC, animated: true)
            //self.navigationController?.presViewController(webVC, animated: true)
        }
        else {
            print("nil url")
        }
    }
}
