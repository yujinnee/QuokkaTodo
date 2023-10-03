//
//  BaseCollectionViewCell.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        
    }
    func setConstraints() {
        
    }
}

