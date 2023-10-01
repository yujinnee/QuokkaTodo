//
//  TodoCollectionViewCell.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import UIKit

class TodoCollectionViewCell: BaseCollectionViewCell {
    
    private let checkboxImageView = {
        let view = UIImageView()
//        view.image = UIImage(systemName: "checkmark.square")
        view.image = UIImage(systemName: "square")
        view.tintColor = .systemGray3
        return view
    }()
    private let todoLabel = {
        let view = UILabel()
        view.font = Pretendard.size13.regular()
        view.numberOfLines = 1
        return view
    }()
    private let menuButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        view.tintColor = UIColor.systemGray2
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func setConstraints() {
        contentView.addSubviews([checkboxImageView,todoLabel,menuButton])
        
        checkboxImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(checkboxImageView.snp.width)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(16)
            make.height.equalTo(menuButton.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(todo: String) {
        todoLabel.text = todo
    }
    
}
