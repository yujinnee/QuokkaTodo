//
//  TodoCollectionViewCell.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/28.
//

import UIKit

class TodoCollectionViewCell: BaseCollectionViewCell {
    var isRevising = false
    var todoText = ""
    var menuButtonTappedClosure: (()->Void)?
//    var deleteButtonTappedClosure: (()->Void)?
//    var reviseButtonTappedClosure: ((String)->Void)?
//    var reviseCompleteButtonTappedClosure: ((String)->Void)?
//
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
    private let todoTextField = {
        let view = UITextField()
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
//    private let reviseButton = {
//        let view = UIButton()
//        view.setImage(UIImage(systemName: "pencil"), for: .normal)
//        view.tintColor = UIColor.systemGray2
//        return view
//
//    }()
//    private let deleteButton = {
//        let view = UIButton()
//        view.setImage(UIImage(systemName: "minus.circle"), for: .normal)
//        view.tintColor = UIColor.systemGray2
//        return view
//
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTargets()
        setDelegate()
        setRevising(isRevising: false)
    }
    func setDelegate() {
        todoTextField.delegate = self
    }
    
    func addTargets(){
//        reviseButton.addTarget(self, action: #selector(reviseButtonDidTapped), for: .touchUpInside)
//        deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(menuButtonDidTapped), for: .touchUpInside)
        todoTextField.addTarget(self, action: #selector(todoTextFieldTextChanged), for: .editingChanged)
    }
//    func setTextFieldCursor() {
//        let endPosition = todoTextField.endOfDocument
//        todoTextField.selectedTextRange = todoTextField.textRange(from: endPosition, to: endPosition)
//
//    }
    @objc func todoTextFieldTextChanged(){
        print("reviseButtonTapped")
        todoText = todoTextField.text ?? ""
    }
    @objc func menuButtonDidTapped() {
            menuButtonTappedClosure?()
            print("menuButtonTappedcell")
    }
//    @objc func reviseButtonDidTapped() {
//        reviseButtonTappedClosure?()
//        print("reviseButtonTappedcell")
//        todoTextField.becomeFirstResponder()
//        setRevising(isRevising: true)
//    }
//    @objc func deleteButtonDidTapped() {
//        print("deleteButtonTappedcell")
//        deleteButtonTappedClosure?()
//    }
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
//        deleteButton.snp.makeConstraints { make in
//            make.trailing.equalTo(reviseButton.snp.leading).offset(-50)
//            make.width.equalTo(16)
//            make.height.equalTo(deleteButton.snp.width)
//        }
//        reviseButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(20)
//            make.width.equalTo(16)
//            make.height.equalTo(reviseButton.snp.width)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(todo: String) {
        todoText = todo
        todoLabel.text = todo
    }
    func setRevising(isRevising: Bool) {
        switch isRevising{
        case true:
            todoLabel.isHidden = true
            print(todoText)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if todoTextField.text?.count != 0 {
            todoText = todoTextField.text ?? ""
//            setRevising(isRevising: false)
//            reviseCompleteButtonTappedClosure?(todoText)
            return true
        }
       return false
    }

}

