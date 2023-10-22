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
        view.font = Pretendard.size16.light()
        return view
    }()
    private let plusImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName:"plus.circle.fill")
        view.tintColor = QColor.accentColor
        return view
    }()
    private let addButton = {
        let view = UIButton()
        view.layer.borderColor = QColor.grayColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
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
        addSubviews([titleLabel,plusImageView,addButton])
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            
        }
        plusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
            make.verticalEdges.equalToSuperview().inset(10)
            make.width.equalTo(plusImageView.snp.height)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading).offset(-7)
            make.trailing.equalTo(plusImageView.snp.trailing).offset(7)
            make.verticalEdges.equalToSuperview().inset(5)
        }
    }
//    func hideAddButton(){
//        addButton.isHidden = true
//    }
    
    func setTitle(text: String) {
        titleLabel.text = text
    }

    func setFocused(isEditing: Bool){
        switch isEditing{
        case true:
            titleLabel.font = Pretendard.size18.semibold()
            addButton.tintColor = QColor.accentColor
            titleLabel.textColor = QColor.accentColor
        case false:
            titleLabel.font = Pretendard.size16.light()
            addButton.tintColor =  QColor.accentColor
            titleLabel.textColor =  QColor.accentColor
        }
       
    }
    
    
}
