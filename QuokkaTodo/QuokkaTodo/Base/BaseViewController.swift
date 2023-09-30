//
//  BaseViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
//        dismissKeyboardWhenTappedAround()
    }
    
    func configureView() {
        view.backgroundColor = .white

    }
    
    func setConstraints() {
    }
//    func dismissKeyboardWhenTappedAround() {
//        
//        let tap: UITapGestureRecognizer =
//            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        self.view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//        self.view.endEditing(true)
//    }
}
