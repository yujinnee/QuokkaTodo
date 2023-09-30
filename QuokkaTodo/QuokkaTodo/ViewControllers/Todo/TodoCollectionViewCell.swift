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
        view.tintColor = .systemGray2
        return view
    }()
    private let todoLabel = {
        let view = UILabel()
        view.font = Pretendard.size13.regular()
        view.numberOfLines = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func setConstraints() {
        contentView.addSubview(checkboxImageView)
        contentView.addSubview(todoLabel)
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(todo: String) {
        todoLabel.text = todo
    }
    
}