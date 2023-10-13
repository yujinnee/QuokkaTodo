//
//  Int+Extension.swift
//  QuokkaTodo
//
//  Created by 이유진 on 2023/10/05.
//

import Foundation

extension Int {
//    var timeFormatString: String {
//        return String(format:"%02d:%02d",self/60, self%60)
//    }
    
}

extension Double {
    var timeFormatString: String {
        return String(format:"%02d:%02d",Int(self/60), Int(self.truncatingRemainder(dividingBy: 60)))
    }
    
}
