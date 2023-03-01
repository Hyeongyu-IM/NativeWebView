//
//  Utils.swift
//  nativeWebView
//
//  Created by 임현규 on 2023/03/02.
//

import Foundation

extension Date {
    static func withMillisecond() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        return dateFormatter.string(from: date)
    }
}
