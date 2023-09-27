//
//  HomeViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit
import Reachability
import SVProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var searchControler: UISearchBar!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var newsCategory: UICollectionView!
    private var remoteViewModel = RemoteNewsViewModel()
    private var tableDataSources : NewsDataSources?
    private var collectionDataSource : CategoryDataSource?
    private var categoryList: [Category]?
    private let errorView = (Bundle.main.loadNibNamed("ErrorDataView", owner: HomeViewController.self, options: nil)?.first as! ErrorDataView)
    private let dataView = Bundle.main.loadNibNamed("NewsDataView", owner: HomeViewController.self, options: nil)?.first as! NewsDataView
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControler.delegate = self
        categoryList = [Category(CategoryName: NSLocalizedString("general", comment: ""), cattegoryImage: "generalIcon"),
                        Category(CategoryName: NSLocalizedString("business", comment: ""), cattegoryImage: "businessIcon"),
                        Category(CategoryName: NSLocalizedString("entertainment", comment: ""), cattegoryImage: "entertainmentIcon"),
                        Category(CategoryName: NSLocalizedString("health", comment: ""), cattegoryImage: "healthIcon"),
                        Category(CategoryName: NSLocalizedString("science", comment: ""), cattegoryImage: "scienceIcon"),
                        Category(CategoryName: NSLocalizedString("technology", comment: ""), cattegoryImage: "technologyIcon"),
                        Category(CategoryName: NSLocalizedString("sports", comment: ""), cattegoryImage: "sportIcon")]
        configureViewsForLocalization()
        registerCell()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        showProgressIndicator()
        requestNewsList()
        bindCategoriesToDataSource()
    }
    func registerCell(){
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
        self.showProgressIndicator()
        if Reachability.forInternetConnection().isReachable() {
            remoteViewModel.getNews(category: category) { [unowned self] result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(let response):
                   
                    if let titleResponse = response?.articles?.first?.title {
                        print (titleResponse)
                        bindNewsToDataSource(newsResponse: response)
                    }
                    else {
                        self.dismissProgressIndicator()
                        handleError(error: .customError(""))
                    }
                case .failure(let error):
                    self.dismissProgressIndicator()
                    handleError(error: error)
                    print(error.localizedDescription)
                }
            }
        }
        else {
            SVProgressHUD.dismiss()
            handleError(error: .networkFailure)
        }
    }
    
    func bindNewsToDataSource(newsResponse response: News?){
        let newsSectionViewModel = NewsSectionViewModel(response?.articles ?? [Article]())
        self.tableDataSources = .init(newsSectionViewModel)
        self.tableDataSources?.navigationProtocol = self
        dataView.frame = self.tableStackView.bounds
        self.tableStackView.addSubview(dataView)
        dataView.tableNews.delegate = tableDataSources
        dataView.tableNews.dataSource = tableDataSources
        dataView.tableNews.reloadData()
    }
    
    /*func setRefreshController(){
        refreshController.tintColor = .systemGray6
        refreshController.addTarget(self, action: #selector(requestNewsList), for: .valueChanged)
        dataView.tableNews.addSubview(refreshController)
    }*/
}
/// configure view items for localization
extension HomeViewController {
    private func configureViewsForLocalization(){
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
                    print (response?.articles?.first?.title ?? "no data")
                    bindNewsToDataSource(newsResponse: response)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension HomeViewController: ICategorySelection {
    func getNewsWithCategory(categoryType: String) {
        print("maamoun")
        dataView.tableNews.reloadData()
        self.requestNewsList(category: categoryType)
    }
    
    func handleError(error: ServiceError) {
        errorView.frame = self.tableStackView.bounds
        self.tableStackView.addSubview(errorView)
        errorView.imgError.image = UIImage(named: "errorImg")
        switch (error) {
        case .networkFailure:
            errorView.lblError.text = NSLocalizedString("networkFailure", comment: "")
            print("No internet connection")
            
        case .ClinetError:
            errorView.lblError.text = NSLocalizedString("ClinetError", comment: "")
            print("Bad request.. please try agian")
            
        case .ServerError:
            errorView.lblError.text = NSLocalizedString("serverError", comment: "")
            print("Server error.. please try again later")
            
        case .invalidResponse:
            errorView.lblError.text = NSLocalizedString("invalidResponse", comment: "")
            print("Bad response")
            
        case .decodingError:
            errorView.lblError.text = NSLocalizedString("decodingError", comment: "")
            print("Error while getting response from the server")
            
        case .encodingError:
            errorView.lblError.text = NSLocalizedString("encodingError", comment: "")
            print("Error while sending requset to server")
            
        case .customError(_):
            //errorView.lblError.text = NSLocalizedString("customError", comment: "")
            errorView.lblError.text = NSLocalizedString("errorMSG", comment: "")
            print("defualt error")
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
extension HomeViewController: IndicatorProtocol {
     func showProgressIndicator(){
        SVProgressHUD.setBackgroundColor(.systemBackground)
        SVProgressHUD.setForegroundColor(UIColor(named: "secondRed")!)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
     func dismissProgressIndicator(){
        SVProgressHUD.dismiss()
    }
}
