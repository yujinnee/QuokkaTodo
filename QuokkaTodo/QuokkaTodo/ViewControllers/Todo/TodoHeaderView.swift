//
//  TodoHeaderView.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/30.
//

import UIKit

class TodoHeaderView: BaseCollectionReusableView {
    
    var addButtonCompletionHandler: (()->Void)?
    var moreButtonCompletionHandler: ((Bool) -> Void)?
    var hasMoreButton = false {
        didSet {
            moreButton.isHidden = !hasMoreButton
        }
    }
    var isFolded: Bool = false {
        didSet {
            let image = isFolded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
            moreButton.setImage(image, for: .normal)
        }
    }
    
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
    private let moreButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        view.tintColor = QColor.subLightColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonTapped() {
        addButtonCompletionHandler?()
    }
    @objc func moreButtonTapped() {
        print("tapped")
        print(isFolded)
        switch isFolded {
        case true:
            isFolded = false
            moreButtonCompletionHandler?(false)
        case false:
            isFolded = true
            moreButtonCompletionHandler?(true)
        }
      
    }
    override func setConstraints() {
        addSubviews([titleLabel,plusImageView,addButton,moreButton])
        
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
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(30)
        }
    }
    func hideAddButton(){
        addButton.isHidden = true
        plusImageView.isHidden = true
    }
    
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
