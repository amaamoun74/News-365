//
//  SavedNewsViewController.swift
//  News-365
//
//  Created by ahmed on 26/08/2023.
//

import UIKit

class SavedNewsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleSaved: UINavigationItem!
    @IBOutlet weak var savedNewsTable: UITableView!
    private var tableDataSources : NewsDataSources?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var localViewModel = LocalNewsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    func registerCell(){
        savedNewsTable.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchAllSavedNewsFromCoreData()
    }
}

extension SavedNewsViewController {
    func fetchAllSavedNewsFromCoreData(){
        localViewModel.fetchNews(appDelegate: appDelegate) { articles in
            if articles.isEmpty == false
            {
                print("Saved news: \(articles)")
                bindNewsToDataSource(articles: articles)
            }
            else {
                savedNewsTable.isHidden = true
                savedNewsTable.reloadData()
                print("Empty core data")
            }
        }
    }
    
    func bindNewsToDataSource(articles: [Article]?){
        let newsSectionViewModel = NewsSectionViewModel(articles ?? [Article]())
        dump(articles ?? [Article]())
        self.tableDataSources = .init(newsSectionViewModel)
        self.tableDataSources?.render = self
        self.tableDataSources?.navigationProtocol = self
        self.savedNewsTable.delegate = tableDataSources
        self.savedNewsTable.dataSource = tableDataSources
        self.savedNewsTable.reloadData()
        savedNewsTable.isHidden = false
    }
}

extension SavedNewsViewController: IRenderView {
    func reload(){
        fetchAllSavedNewsFromCoreData()
    }
}
extension SavedNewsViewController: NavigationProtocol {
    func navigateToWebView(articalURL: String?) {
        if let url = articalURL {
            let webVC = self.storyboard!.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
            webVC.articaleURL = url
            //self.present(webVC, animated: true)
            self.navigationController?.pushViewController(webVC, animated: true)
            
        }
        else {
            print("nil url")
        }
    }
}
