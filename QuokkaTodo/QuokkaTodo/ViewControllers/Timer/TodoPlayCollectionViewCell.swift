//
//  TodoPlayCollectionViewCell.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/10/23.
//

import UIKit

class TodoPlayCollectionViewCell: BaseCollectionViewCell {
    private let todoLabel = {
        let view = UILabel()
        view.font = Pretendard.size15.medium()
        view.isHidden = false
        view.numberOfLines = 1
        return view
    }()
    private let playButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "play.circle"), for: .normal)
        view.tintColor = QColor.accentColor
        return view

    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        contentView.addSubviews([todoLabel,playButton])
        
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        playButton.snp.makeConstraints { make in
                   make.trailing.equalToSuperview().inset(20)
                   make.width.equalTo(20)
                   make.height.equalTo(playButton.snp.width)
        }
    }
    
    func setData(todo: String) {
        todoLabel.text = todo
    }
}

