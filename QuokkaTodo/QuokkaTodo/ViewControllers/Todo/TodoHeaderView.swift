//
//  TodoHeaderView.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/30.
//

import UIKit

class TodoHeaderView: BaseCollectionReusableView {
    private let titleLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = QColor.accentColor
        view.font = Pretendard.size18.bold()
        return view
    }()
    
    private let plusButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName:"plus.circle"), for: .normal)
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
        addSubviews([titleLabel,plusButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }

    
    
}
