//
//  DiaryWritingViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import UIKit

class DiaryWritingViewController: BaseViewController {
    let diaryRepository = DiaryRepository()
    let nutritionRepository = FeedNutritionRepository()
    let levelRepository = LevelRepository()
    var diaryWritingCompletedCompletion: (() -> Void)?
    let maxLength = 200
    
    private let popupView = {
        let view = UIView()
        view.backgroundColor = QColor.backgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    private let diaryDecisionLabel = {
        let view = UILabel()
        view.text = "오늘의 행복일기 한 줄을 작성해주세요."
        view.font = Pretendard.size18.medium()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    private let subDecisionLabel = {
        let view = UILabel()
        view.text = " 작성해 주신 행복일기는 제가 잘 모아 소중히 보관하다\n올 해의 마지막 날 돌려 드려요!"
        view.textColor = UIColor.systemGray
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = Pretendard.size12.medium()
        return view
    }()
    private let diaryBorderView = {
        let view = UIView()
        view.layer.borderColor = QColor.accentColor.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 10
        return view
    }()
    private let diaryTextfield = {
        let view = UITextField()
        view.borderStyle = .none
        view.font = Pretendard.size12.medium()
        view.placeholder = "소소한 행복이라도 충분해요!"
        return view
    }()
    private let completeButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = QColor.grayColor
        config.baseForegroundColor = QColor.backgroundColor
        let view = UIButton()
        view.configuration = config
        var titleContainer = AttributeContainer()
        titleContainer.font = Pretendard.size18.medium()
        view.configuration?.attributedTitle = AttributedString("작성완료", attributes: titleContainer)
        view.isEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        addTargets()
        addDismissScreenPanGesture()
        addDismissKeyboardTapGesture()
        setTextField()
    }
    func setTextField(){
        diaryTextfield.delegate = self
        diaryTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    func addDismissScreenPanGesture() {
        let tap: UIPanGestureRecognizer =
        UIPanGestureRecognizer(target: self, action: #selector(dismissScreen))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func addDismissKeyboardTapGesture() {
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissScreen() {
        dismiss(animated: true)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addTargets(){
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    @objc func completeButtonTapped(){
        
        let alert = UIAlertController(title: "확인 사항", message: "오늘의 행복 일기는 하루에 한 번 작성 가능하며 수정 및 삭제가 불가능 합니다. 작성 완료하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "완료", style: .default) { _ in
            self.diaryRepository.createDiary(Diary(contents:  self.diaryTextfield.text ?? "", createdDate: DateFormatter.convertToFullDateDBForm(date: Date())))
            self.nutritionRepository.createFeedNutrition(FeedNutrition(feedNutritionTime: DateFormatter.convertToFullDateDBForm(date: Date())))
            var nutritionNum =  self.levelRepository.readNutritionNum() + 1
            self.nutritionRepository.createFeedNutrition(FeedNutrition(feedNutritionTime:  DateFormatter.convertToFullDateDBForm(date: Date())))
            self.levelRepository.updateNutirionNum(num: nutritionNum)
            self.diaryWritingCompletedCompletion?()
            self.dismiss(animated: true)
        }
        cancel.setValue(QColor.accentColor, forKey: "titleTextColor")
        ok.setValue(QColor.accentColor, forKey: "titleTextColor")
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
        
    }
    override func configureView() {
        view.addSubview(popupView)
        popupView.addSubviews([diaryDecisionLabel,subDecisionLabel,diaryBorderView,completeButton])
        diaryBorderView.addSubview(diaryTextfield)
        
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        diaryDecisionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        subDecisionLabel.snp.makeConstraints { make in
            make.top.equalTo(diaryDecisionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        diaryBorderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(subDecisionLabel.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        diaryTextfield.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        completeButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.top.equalTo(diaryTextfield.snp.bottom ).offset(20)
            make.centerX.equalToSuperview()
            
        }
    }
    
}
extension DiaryWritingViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if(textField.text!.count == 0){
//            completeButton.setTitleColor(QColor.grayColor, for: .normal)
            completeButton.configuration?.baseBackgroundColor = QColor.grayColor
            completeButton.isEnabled = false
        }else {
//            completeButton.setTitleColor(QColor.accentColor, for: .normal)
            completeButton.configuration?.baseBackgroundColor = QColor.accentColor
            completeButton.isEnabled = true
        }
    }
    @objc func textFieldDidChange(){
        if(diaryTextfield.text!.count == 0){
//            completeButton.setTitleColor(QColor.grayColor, for: .normal)
            completeButton.configuration?.baseBackgroundColor = QColor.grayColor
            completeButton.isEnabled = false
        }else {
//            completeButton.setTitleColor(QColor.accentColor, for: .normal)
            completeButton.configuration?.baseBackgroundColor = QColor.accentColor
            completeButton.isEnabled = true
        }
        let textString = diaryTextfield.text!
        if textString.count >= maxLength {
            let index = textString.index(textString.startIndex, offsetBy: maxLength)
            let fixedText = textString[textString.startIndex..<index]
            diaryTextfield.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.diaryTextfield.text = String(fixedText)
            }
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

