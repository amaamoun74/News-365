//
//  HomeViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit
import Reachability
import SVProgressHUD
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var searchControler: UISearchBar!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var newsCategory: UICollectionView!
    private var viewModel: RemoteNewsViewModel?
    private var remoteViewModel = RemoteNewsViewModel()
    private var tableDataSources : NewsDataSources?
    private var collectionDataSource : CategoryDataSource?
    private var categoryList: [Category]?
    private var operationQueu = OperationQueue()
    private var cancellables: Set<AnyCancellable> = []
    private let errorView = (Bundle.main.loadNibNamed("ErrorDataView", owner: HomeViewController.self, options: nil)?.first as! ErrorDataView)
    private let dataView = Bundle.main.loadNibNamed("NewsDataView", owner: HomeViewController.self, options: nil)?.first as! NewsDataView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControler.delegate = self
        setCategoryList()
        configureViewsForLocalization()
        registerCell()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        showProgressIndicator()
        setOperationQueue()
    }
    
    func setCategoryList(){
        categoryList = [Category(CategoryName: NSLocalizedString("general", comment: ""), cattegoryImage: "generalIcon"),
                        Category(CategoryName: NSLocalizedString("business", comment: ""), cattegoryImage: "businessIcon"),
                        Category(CategoryName: NSLocalizedString("entertainment", comment: ""), cattegoryImage: "entertainmentIcon"),
                        Category(CategoryName: NSLocalizedString("health", comment: ""), cattegoryImage: "healthIcon"),
                        Category(CategoryName: NSLocalizedString("science", comment: ""), cattegoryImage: "scienceIcon"),
                        Category(CategoryName: NSLocalizedString("technology", comment: ""), cattegoryImage: "technologyIcon"),
                        Category(CategoryName: NSLocalizedString("sports", comment: ""), cattegoryImage: "sportIcon")]
    }
    
    func setOperationQueue(){
        let firstOperation = BlockOperation{
            OperationQueue.main.addOperation {
                self.requestNews()
            }
        }
        let secondOperation = BlockOperation{
            OperationQueue.main.addOperation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {                self.bindCategoriesToDataSource()
                    }
            }
        }
        secondOperation.addDependency(firstOperation)
        operationQueu.addOperations([firstOperation,secondOperation], waitUntilFinished: true)
        operationQueu.cancelAllOperations()
    }
    
    func registerCell(){
        newsCategory.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsCatgeogry")
    }
    
    func bindCategoriesToDataSource(){
        lblCategory.text = NSLocalizedString("category", comment: "")
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
    private func setupViewModel(){
        viewModel = RemoteNewsViewModel()
    }
    
    private func requestNews(category: String = "general") {
        self.showProgressIndicator()
        viewModel?.fetchNews(category: category)
        viewModel?.$news
            .receive(on: DispatchQueue.main)
            //.compactMap{ $0 }
            .sink { [weak self] newsResponse in
                //     dump("title \(String(describing: newsResponse.articles?.first?.title))")
                guard newsResponse.articles != nil else {
                    self?.showProgressIndicator()
                    return
                }
                //self?.bindNewsToDataSource(newsResponse: newsResponse)
                if newsResponse.articles != nil && newsResponse.articles?.count ?? -1 > 0    {
                    self?.bindNewsToDataSource(newsResponse: newsResponse)
                }
                else {
                    //self?.handleError(errorMSG: NSLocalizedString("errorMSG", comment: ""))
                    self?.viewModel?.$errorMessage
                        .receive(on: RunLoop.main)
                        .sink { [weak self] errorMessage in
                            self?.handleError(errorMSG: errorMessage)
                        }
                        .store(in: &self!.cancellables)
                }
                
            }
            .store(in: &cancellables)

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
        self.dismissProgressIndicator()
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
        showProgressIndicator()
        dataView.tableNews.reloadData()
        self.requestNews(category: categoryType)
    }
    
    func handleError(errorMSG: String) {
        self.dismissProgressIndicator()
        errorView.frame = self.tableStackView.bounds
        self.tableStackView.addSubview(errorView)
        errorView.imgError.image = UIImage(named: "errorImg")
        errorView.lblError.text = errorMSG
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
