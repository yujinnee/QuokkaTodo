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
    func makeToastAnimation(message: String){
        let toastMessage = ToastMessageView(message: message)
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.center.equalToSuperview()
//            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        UIView.animate(withDuration: 3.0, animations: {
            toastMessage.alpha = 0
        }, completion: {_ in toastMessage.removeFromSuperview() })
    }
}
