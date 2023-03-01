//
//  webView.swift
//  nativeWebView
//
//  Created by 임현규 on 2023/02/26.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView?
    
    deinit {
        print("deinit WebViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "bridge")
    }
    
    // receive message from wkwebview
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        let date = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.messageToWebview(msg: "hello, I got your messsage: \(message.body) at \(date)")
        }
    }
    
    func messageToWebview(msg: String) {
        self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
    }
    
    func webviewInit() {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "bridge")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        // 3
        let webview = WKWebView(frame: .zero, configuration: configuration)
        self.webView = webview 
        guard let webView = webView else { return }
        
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)

        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}
