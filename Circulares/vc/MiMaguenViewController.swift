//
//  MiMaguenViewController.swift
//  Circulares
//
//  Created by Rafael David Castro Luna on 28/7/23.
//

import UIKit
import WebKit

class MiMaguenViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        let link = URL(string:"https://www.chmd.edu.mx/pruebascd/icloud/")!
        let request = URLRequest(url: link)
        self.webView.configuration.preferences.javaScriptEnabled = true
        self.webView.load(request)
    }
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
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
