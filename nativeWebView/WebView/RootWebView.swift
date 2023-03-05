//
//  webView.swift
//  nativeWebView
//
//  Created by 임현규 on 2023/02/26.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private var headers: [String: String] {
        let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        var header = ["Content-Type": "application/json"]
        header["app-device-uuid"] = UUID().uuidString
        header["app-device-os-version"] = UIDevice.current.systemVersion
        header["app-device-device-manufacturer"] = "apple"
        header["app-version"] = bundleVersion
        return header
    }
    
    var webView: WKWebView?
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView?.evaluateJavaScript("viewWillDisappear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "bridge")
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "htmlLoaded")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView?.evaluateJavaScript("viewDidDisappear()", completionHandler: { (result, erorr) in
            print("Date \(Date.withMillisecond()) result ---- \(result)")
        })
    }
    
    func messageToWebview(msg: String) {
        self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
        self.webView?.evaluateJavaScript("webkit.messageHandlers.htmlLoaded.onMessage('didn't send Anything')")
    }
    
    func webviewInit() {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "bridge")
        userContentController.add(self, name: "htmlLoaded")
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
        var urlRequest = URLRequest(url: url)
        headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
//        webView.loadFileURL(url, allowingReadAccessTo: url)
        webview.load(urlRequest)
    }
}

extension WebViewController: WKNavigationDelegate {
    ///WKWebView에서 특정 화면 이동, 클릭 시 webView(_:decidePolicyFor:decisionHandler:)에서 url 수신
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("링크 =>\(navigationAction.request.url)")
        decisionHandler(.allow)
    }
}

extension WebViewController: WKScriptMessageHandler {
    // receive message from wkwebview
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message.body \(message.body)")
        let date = Date()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            //Success했을 경우 웹뷰로 해당 신호를 보냄
            self?.messageToWebview(msg: "hello, I got your messsage: \(message.body) at \(date)")
        }
    }
}


