//
//  BaseView.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
//        dismissKeyboardWhenTappedAround()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        
    }
    
    func setConstraints() {
        
    }
//    func dismissKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer =
//            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        self.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//        self.endEditing(true)
//    }
}

