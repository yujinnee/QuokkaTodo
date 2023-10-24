//
//  WebViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/23/23.
//

import UIKit
import WebKit

class WebViewController: BaseViewController,WKUIDelegate {
    
    var webView = WKWebView()
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let url = URL(string:urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        //           navigationController?.navigationBar.isTranslucent = false
    }
    
}
