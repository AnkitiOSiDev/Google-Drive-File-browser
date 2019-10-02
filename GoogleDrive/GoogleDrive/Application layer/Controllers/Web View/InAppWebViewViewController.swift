//
//  InAppWebViewViewController.swift
//  GoogleDrive
//
//  Created by Ankit on 20/04/19.
//  Copyright © 2019 Ankit. All rights reserved.
//

import UIKit
import WebKit
class InAppWebViewViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var filePath : String?
    var fileName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = fileName ?? ""
        let url = URL(fileURLWithPath: filePath!)
        let request = NSURLRequest(url: url)
        webView.load(request as URLRequest)
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
