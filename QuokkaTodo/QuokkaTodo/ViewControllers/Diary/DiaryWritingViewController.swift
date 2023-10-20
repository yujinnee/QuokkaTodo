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
        view.text = " 헹복일기는 영양제가 되어 쿼카가 더 잘 자라게 해준답니다.하루 한번 작성 가능하며 작성한 일기는 쿼카가 잘 가지고 있다가 연말에 모아서 보여드립니다! (수정,삭제가 불가합니다.)"
        view.textColor = UIColor.systemGray
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = Pretendard.size9.medium()
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
        return view
    }()
    
    private let completeButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = QColor.accentColor
        config.baseForegroundColor = QColor.backgroundColor
        let view = UIButton()
        view.configuration = config
        var titleContainer = AttributeContainer()
        titleContainer.font = Pretendard.size18.medium()
        view.configuration?.attributedTitle = AttributedString("작성완료", attributes: titleContainer)
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        addTargets()
    }
    
    private func addTargets(){
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    @objc func completeButtonTapped(){
        diaryRepository.createDiary(Diary(contents: diaryTextfield.text ?? "", createdDate: DateFormatter.convertToFullDateDBForm(date: Date())))
        nutritionRepository.createFeedNutrition(FeedNutrition(feedNutritionTime: DateFormatter.convertToFullDateDBForm(date: Date())))
        var nutritionNum = levelRepository.readNutritionNum() + 1
        nutritionRepository.createFeedNutrition(FeedNutrition(feedNutritionTime:  DateFormatter.convertToFullDateDBForm(date: Date())))

        levelRepository.updateNutirionNum(num: nutritionNum)
        
       
//        dismiss(animated: true)
        diaryWritingCompletedCompletion?()
        dismiss(animated: true)
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
            make.height.equalTo(30)
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
