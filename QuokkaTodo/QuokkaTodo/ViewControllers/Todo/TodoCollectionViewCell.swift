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
    let todoLabel = {
        let view = UILabel()
        view.font = Pretendard.size15.regular()
        view.isHidden = false
        view.numberOfLines = 0
        view.lineBreakMode = .byTruncatingTail
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
//        view.isHidden = true
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    private let firstLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf.fill")
        view.tintColor = QColor.subLightAlphaColor
        return view
    }()
    private let secondLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf.fill")
        view.tintColor = QColor.subLightAlphaColor
        return view
    }()
    private let thirdLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf.fill")
        view.tintColor = QColor.subLightAlphaColor
        return view
    }()
    private let fourthLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf.fill")
        view.tintColor = QColor.subLightAlphaColor
        return view
    }()
    private let fifthLeafImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "leaf.fill")
        view.tintColor = QColor.subLightAlphaColor
        return view
    }()
    private let leafNumLabel = {
        let view = UILabel()
        view.font = Pretendard.size9.semibold()
//        view.tintColor = QColor.subLightAlphaColor
        view.tintColor = QColor.fontColor
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
        setLeaf(leafNum: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        todoLabel.preferredMaxLayoutWidth = todoLabel.frame.size.width
        super.layoutSubviews()
        
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
        firstLeafImageView.addSubview(leafNumLabel)
        
        checkboxImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(checkboxImageView.snp.width)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        todoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(1)
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)
            make.trailing.equalTo(menuButton.snp.leading).offset(-20)
            make.bottom.equalTo(leafStackView.snp.top)
        }
        todoTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        leafStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(10)
            make.height.equalTo(11)
            make.bottom.equalToSuperview()

        }
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(menuButton.snp.height)
        }
        firstLeafImageView.snp.makeConstraints { make in
            make.width.equalTo(firstLeafImageView.snp.height)
        }
        secondLeafImageView.snp.makeConstraints { make in
            make.width.equalTo(secondLeafImageView.snp.height)
        }
        thirdLeafImageView.snp.makeConstraints { make in
            make.width.equalTo(thirdLeafImageView.snp.height)
        }
        fourthLeafImageView.snp.makeConstraints { make in
            make.width.equalTo(fourthLeafImageView.snp.height)
        }
        fifthLeafImageView.snp.makeConstraints { make in
            make.width.equalTo(fifthLeafImageView.snp.height)
        }
        leafNumLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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
            checkboxImageView.image = UIImage(systemName: "checkmark.square.fill")
        case false:
            checkboxImageView.image = UIImage(systemName: "square")
        }
    }
    func setLeaf(leafNum: Int){
        switch leafNum{
        case 0:
            leafNumLabel.isHidden = true
//            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightAlphaColor
            secondLeafImageView.tintColor = QColor.subLightAlphaColor
            thirdLeafImageView.tintColor = QColor.subLightAlphaColor
            fourthLeafImageView.tintColor = QColor.subLightAlphaColor
            fifthLeafImageView.tintColor = QColor.subLightAlphaColor
        case 1:
            leafNumLabel.isHidden = true
//            leafStackView.isHidden = false
//            firstLeafImageView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.tintColor = QColor.subLightAlphaColor
            thirdLeafImageView.tintColor = QColor.subLightAlphaColor
            fourthLeafImageView.tintColor = QColor.subLightAlphaColor
            fifthLeafImageView.tintColor = QColor.subLightAlphaColor
//            secondLeafImageView.isHidden = true
//            thirdLeafImageView.isHidden = true
//            fourthLeafImageView.isHidden = true
//            fifthLeafImageView.isHidden = true
        case 2:
            leafNumLabel.isHidden = true
//            leafStackView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.tintColor = QColor.subLightColor
            thirdLeafImageView.tintColor = QColor.subLightAlphaColor
            fourthLeafImageView.tintColor = QColor.subLightAlphaColor
            fifthLeafImageView.tintColor = QColor.subLightAlphaColor
          
//            firstLeafImageView.isHidden = false
//            secondLeafImageView.isHidden = false
//            thirdLeafImageView.isHidden = true
//            fourthLeafImageView.isHidden = true
//            fifthLeafImageView.isHidden = true
        case 3:
            leafNumLabel.isHidden = true
//            leafStackView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.tintColor = QColor.subLightColor
            thirdLeafImageView.tintColor = QColor.subLightColor
            fourthLeafImageView.tintColor = QColor.subLightAlphaColor
            fifthLeafImageView.tintColor = QColor.subLightAlphaColor
//            firstLeafImageView.isHidden = false
//            secondLeafImageView.isHidden = false
//            thirdLeafImageView.isHidden = false
//            fourthLeafImageView.isHidden = true
//            fifthLeafImageView.isHidden = true
        case 4:
            leafNumLabel.isHidden = true
//            leafStackView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.tintColor = QColor.subLightColor
            thirdLeafImageView.tintColor = QColor.subLightColor
            fourthLeafImageView.tintColor = QColor.subLightColor
            fifthLeafImageView.tintColor = QColor.subLightAlphaColor
//            firstLeafImageView.isHidden = false
//            secondLeafImageView.isHidden = false
//            thirdLeafImageView.isHidden = false
//            fourthLeafImageView.isHidden = false
//            fifthLeafImageView.isHidden = true
        case 5:
            leafNumLabel.isHidden = true
//            leafStackView.isHidden = false
            secondLeafImageView.isHidden = false
            thirdLeafImageView.isHidden = false
            fourthLeafImageView.isHidden = false
            fifthLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.tintColor = QColor.subLightColor
            thirdLeafImageView.tintColor = QColor.subLightColor
            fourthLeafImageView.tintColor = QColor.subLightColor
            fifthLeafImageView.tintColor = QColor.subLightColor
//            firstLeafImageView.isHidden = false
//            secondLeafImageView.isHidden = false
//            thirdLeafImageView.isHidden = false
//            fourthLeafImageView.isHidden = false
//            fifthLeafImageView.isHidden = false
            
        default:
            leafNumLabel.isHidden = false
            leafNumLabel.text = "\(leafNum)"
//            leafStackView.isHidden = false
//            firstLeafImageView.isHidden = false
            firstLeafImageView.tintColor = QColor.subLightColor
            secondLeafImageView.isHidden = true
            thirdLeafImageView.isHidden = true
            fourthLeafImageView.isHidden = true
            fifthLeafImageView.isHidden = true
            
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


