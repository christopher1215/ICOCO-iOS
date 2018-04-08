//
//  WebVC.swift
//  ICOCO
//
//  Created by hsgu on 2018. 1. 26..
//  Copyright © 2018년 Prangbi. All rights reserved.
//

import UIKit
import WebKit

// MARK: - WebVC
class WebVC: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var webViewContainer: UIView!
    
    // MARK: Variable
    internal var indicator: UIActivityIndicatorView? = nil
    internal var mainWebView: WKWebView!
    internal var firstLoaded = false
    internal var urlStr: String? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebVC.pressedShareButton(_:)))
        self.navigationItem.rightBarButtonItems = [shareItem]
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        
        let webConfiguration = WKWebViewConfiguration()
        self.mainWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.mainWebView.uiDelegate = self
        self.mainWebView.navigationDelegate = self
        self.webViewContainer.addSubview(self.mainWebView)
        
        if let urlStr = self.urlStr, let url = URL(string: urlStr), true == UIApplication.shared.canOpenURL(url) {
            if self.mainWebView.isLoading {
                self.mainWebView.stopLoading()
            }
            self.mainWebView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mainWebView.frame = self.webViewContainer.bounds
    }
}

// MARK: - Event
extension WebVC {
    @objc func pressedShareButton(_ sender: Any?) {
        if let urlStr = self.urlStr, let url = URL(string: urlStr) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Function
extension WebVC {
    func setData(url: String?) {
        self.urlStr = url
    }
}

// MARK: - WKWebView
extension WebVC: WKNavigationDelegate, WKUIDelegate {
    // WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url, true == UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        MessageUtil.showAlert(targetVc: self, title: nil, message: message) {
            completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        MessageUtil.showConfirmAlert(targetVc: self, title: nil, message: message) { (isConfirm) in
            completionHandler(isConfirm)
        }
    }
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if false == self.indicator?.isAnimating {
            self.indicator?.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.indicator?.stopAnimating()
        if false == self.firstLoaded {
            MessageUtil.showAlert(targetVc: self, title: nil, message: "Couldn't connect to server.", completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if false == self.firstLoaded {
            self.firstLoaded = true
        }
        self.indicator?.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
