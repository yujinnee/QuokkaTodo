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
    var isCompleted = false
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
    private let leafStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    private let firstLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf")
        view.tintColor = QColor.subDeepColor
        return view
    }()
    private let secondLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf")
        view.tintColor = QColor.subDeepColor
        return view
    }()
    private let thirdLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf")
        view.tintColor = QColor.subDeepColor
        return view
    }()
    private let fourthLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf")
        view.tintColor = QColor.subDeepColor
        return view
    }()
    private let fifthLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf")
        view.tintColor = QColor.subDeepColor
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
        contentView.addSubviews([checkboxImageView,todoLabel,todoTextField,leafStackView,menuButton])
        leafStackView.addArrangedSubview(firstLeafImageView)
        leafStackView.addArrangedSubview(secondLeafImageView)
        leafStackView.addArrangedSubview(thirdLeafImageView)
        leafStackView.addArrangedSubview(fourthLeafImageView)
        leafStackView.addArrangedSubview(fifthLeafImageView)
        
        checkboxImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(checkboxImageView.snp.width)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)

        }
        todoTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        leafStackView.snp.makeConstraints { make in
//            make.bottom.equalTo(todoLabel.snp.bottom)
//            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(todoLabel.snp.trailing).offset(10)
//            make.width.equalTo(150)
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
            leafStackView.isHidden = true
        case false:
            todoLabel.isHidden = false
            todoLabel.text = todoText
            todoTextField.isHidden = true
            leafStackView.isHidden = false
        }
    }
    func setCheckBox(isCompleted: Bool){
        self.isCompleted = isCompleted
        switch isCompleted{
        case true:
            checkboxImageView.image = UIImage(systemName: "checkmark.square")
        case false:
            checkboxImageView.image = UIImage(systemName: "square")
        }
    }
    func setLeaf(leafNum: Int){
        switch leafNum{
        case 0:
            leafStackView.isHidden = true
        case 1:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = true
            thirdLeafImageView.isHidden = true
            fourthLeafImageView.isHidden = true
            fifthLeafImageView.isHidden = true
        case 2:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = true
            fourthLeafImageView.isHidden = true
            fifthLeafImageView.isHidden = true
        case 3:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = true
            fifthLeafImageView.isHidden = true
        case 4:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = true
        case 5:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
        default:
            leafStackView.isHidden = false
            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            
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

