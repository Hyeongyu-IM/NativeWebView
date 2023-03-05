//
//  WebViewPlugInRequest.swift
//  nativeWebView
//
//  Created by 임현규 on 2023/03/05.
//

import WebKit

struct WebViewPluginRequest {
    var command: String
    var parameter: [String: Any]?
    var extra: [String: Any]?
    var message: WKScriptMessage?
}
