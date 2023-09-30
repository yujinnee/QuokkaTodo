//
//  UIView+Extension.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/29.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    func removeAllSubViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
