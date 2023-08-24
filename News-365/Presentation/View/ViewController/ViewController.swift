//
//  ViewController.swift
//  News-365
//
//  Created by ahmed on 22/08/2023.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        request()
    }
    func request (){
        NetworkManager.shared.request(endpoint: .topHeadlines(category: "general", country: "EG"), responseClass: News.self) { result in
            switch result {
            case .success(let response):
                print (response?.articles?.first?.title ?? "no data")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

