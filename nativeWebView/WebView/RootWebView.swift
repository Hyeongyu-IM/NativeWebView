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
    let A = "String A"
    let B = 10
    deinit {
        print("Date \(Date.withMillisecond()) deinit WebViewController")
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewInit()
        webView?.evaluateJavaScript("viewDidLoad()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView?.evaluateJavaScript("viewWillAppear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView?.evaluateJavaScript("viewDidAppear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
//        webView?.evaluateJavaScript("parameterTest('\(A)', '\(B)')", completionHandler: { (result, erorr) in
//            print("Date \(Date.withMillisecond()) result ---- \(result)")
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.evaluateJavaScript("viewWillDisappear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "bridge")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView?.evaluateJavaScript("viewDidDisappear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
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
