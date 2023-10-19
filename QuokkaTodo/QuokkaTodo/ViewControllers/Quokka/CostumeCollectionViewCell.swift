//
//  CostumeCollectionViewCell.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import UIKit

import SnapKit

class CostumeCollectionViewCell: BaseCollectionViewCell {
    let costumeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func configureView() {
        addSubview(costumeImageView)
        costumeImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}
