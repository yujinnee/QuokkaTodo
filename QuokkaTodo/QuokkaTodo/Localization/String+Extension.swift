//
//  String+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
    
    func localized(num1: Int,num2: Int) -> String {
        return String(format: self.localized, num1, num2)
    }
}
