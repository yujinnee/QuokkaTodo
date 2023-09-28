//
//  DateFromatter+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import Foundation

extension DateFormatter {
    static let format = {
        let format = DateFormatter()
        format.dateFormat = "yy년 MM월 dd일"
        return format
    }()
    
    static func today() -> String {
        return format.string(from: Date())
    }
    
    static func convertDate(date: Date) -> String {
        return format.string(from:date)
    }
}
