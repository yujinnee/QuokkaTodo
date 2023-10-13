//
//  TodoHeaderView.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/30.
//

import UIKit

class TodoHeaderView: BaseCollectionReusableView {
    
    var addButtonComletionHandler: (()->Void)?
    
    private let titleLabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = QColor.accentColor
        view.font = Pretendard.size18.light()
        return view
    }()
    
    private let addButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName:"plus.circle"), for: .normal)
        view.tintColor = QColor.accentColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonTapped() {
        addButtonComletionHandler?()
    }
    override func setConstraints() {
        addSubviews([titleLabel,addButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    func hideAddButton(){
        addButton.isHidden = true
    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }

    func setFocused(isEditing: Bool){
        switch isEditing{
        case true:
            titleLabel.font = Pretendard.size20.bold()
            addButton.tintColor = QColor.accentColor
            titleLabel.textColor = QColor.accentColor
        case false:
            titleLabel.font = Pretendard.size18.light()
            addButton.tintColor =  QColor.accentColor
            titleLabel.textColor =  QColor.accentColor
        }
       
    }
    
    
}
