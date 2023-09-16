//
//  WebViewController.swift
//  News-365
//
//  Created by ahmed on 16/09/2023.
//

import UIKit
import WebKit
class WebViewController: UIViewController, WKNavigationDelegate {
    var articaleURL : String?
    
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        let url = URL(string: articaleURL ?? "")
        DispatchQueue.main.async {
            self.webView.load(URLRequest(url: url!))
            self.webView.allowsBackForwardNavigationGestures = true
       
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
