//
//  WebKitViewController.swift
//  NetworkDaily
//
//  Created by wtildestar on 22/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var courseURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard
            let courseURL = courseURL,
            let url = URL(string: courseURL)
            else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
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
