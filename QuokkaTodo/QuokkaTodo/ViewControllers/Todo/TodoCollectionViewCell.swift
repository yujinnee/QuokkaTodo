//
//  TodoCollectionViewCell.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import UIKit
import RealmSwift

class TodoCollectionViewCell: BaseCollectionViewCell {
    var _id: ObjectId?
    var isRevising = false
    var todoText = ""
    var menuButtonTappedClosure: (()->Void)?
    var reviseCompleteButtonTappedClosure: ((String)->Void)?
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
        view.isHidden = false
        view.numberOfLines = 1
        return view
    }()
    private let todoTextField = {
        let view = UITextField()
        view.isHidden = true
        view.font = Pretendard.size13.regular()
        view.returnKeyType = .done
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
        addTargets()
        setDelegate()
    }
    func setDelegate() {
        todoTextField.delegate = self
    }
    
    func addTargets(){
        menuButton.addTarget(self, action: #selector(menuButtonDidTapped), for: .touchUpInside)
        todoTextField.addTarget(self, action: #selector(todoTextFieldTextChanged), for: .editingChanged)
    }
    @objc func todoTextFieldTextChanged(){
        todoText = todoTextField.text ?? ""
    }
    @objc func menuButtonDidTapped() {
            menuButtonTappedClosure?()
    }
    func openKeyboard() {
        todoTextField.becomeFirstResponder()
    }
    override func setConstraints() {
        contentView.addSubviews([checkboxImageView,todoLabel,todoTextField,menuButton])
        
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
        todoTextField.snp.makeConstraints { make in
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
        todoText = todo
        todoLabel.text = todo
    }
    func setRevising(isRevising: Bool) {       
        self.isRevising = isRevising
        switch isRevising{
        case true:
            todoLabel.isHidden = true
            todoTextField.text = todoText
            todoTextField.isHidden = false
        case false:
            todoLabel.isHidden = false
            todoLabel.text = todoText
            todoTextField.isHidden = true
        }
    }
    
}
extension TodoCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        setRevising(isRevising: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if todoTextField.text?.count != 0 {
            todoText = todoTextField.text ?? ""
            setRevising(isRevising: false)
            reviseCompleteButtonTappedClosure?(todoText)
            return true
        }
       return false
    }

}

