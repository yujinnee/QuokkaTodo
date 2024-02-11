//
//  MenuViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 2023/10/01.
//

import UIKit
import RealmSwift

class MenuViewController: BaseViewController {
    let todoRepository = TodoRepository()
    var todoType: TodoType? {
        didSet {
            changeToSoonButton.isHidden = todoType == .spareTodo
            setDateButton.title = todoType == .spareTodo ? "이 날 할일로 옮기기" : "날짜 바꾸기"
        }
    }
    var deleteButtonTappedClosure: (()->Void)?
    var reviseButtonTappedClosure: (()->Void)?
    
    var _id: ObjectId?
    
    private let todoLabel = {
        let view = UILabel ()
        view.text = "투두제목"
        view.textAlignment = .center
        view.font = Pretendard.size20.bold()
        view.numberOfLines = 3
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.7 
        return view
    }()
    private let todoTypeLabel = {
        let view = UILabel ()
        view.textAlignment = .center
        view.textColor = QColor.accentColor
        view.font = Pretendard.size11.medium()
        return view
    }()
    let mainButtonsStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    private let reviseButton = {
        let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.backgroundColor = QColor.subLightColor
        view.setTitleColor(QColor.backgroundColor, for: .normal)
        view.titleLabel?.font = Pretendard.size18.bold()
        view.layer.cornerRadius = 10
        return view
    }()
    private let deleteButton = {
        let view = UIButton()
        view.setTitle("삭제", for: .normal)
        view.backgroundColor = UIColor(red: 255/255, green: 155/255, blue: 158/255, alpha: 1.0)
        view.titleLabel?.font = Pretendard.size18.bold()
        view.setTitleColor(QColor.backgroundColor, for: .normal)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let buttonListStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        view.distribution = .fillEqually
        return view
    }()
    private let setDateButton = menuButton(image: UIImage(systemName: "pencil.circle.fill")!, title: "날짜 지정하기", tintColor: QColor.subDeepColor)
    
    private let changeToSoonButton = menuButton(image: UIImage(systemName: "calendar.circle.fill")!, title: "곧 할일로 옮기기", tintColor: QColor.subDeepColor)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.preferredCornerRadius = 20
        }
        addTargets()
        setTodoLabel()
        setTodoTypeLabel()
        
    }
    private func setTodoTypeLabel() {
        switch todoType {
        case .spareTodo:
            todoTypeLabel.text = "곧 할 일"
        case .todayTodo:
            todoTypeLabel.text = "이날 할 일"
        default :
            break
        }
        
    }
    private func setTodoLabel() {
        guard let _id = _id else {return}
        todoLabel.text = todoRepository.readTodo(_id: _id).contents
    }
    private func addTargets(){
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        reviseButton.addTarget(self, action: #selector(reviseButtonDidTapped), for: .touchUpInside)
        setDateButton.addTarget(self, action: #selector(setDateButtonDidTapped), for: .touchUpInside)
        changeToSoonButton.addTarget(self, action: #selector(setSoonButtonDidTapped), for: .touchUpInside)
    }
    @objc func deleteButtonDidTapped() {
        todoRepository.deleteTodo(_id: _id ?? ObjectId())
        dismiss(animated: true)
        deleteButtonTappedClosure?()
    }
    
    @objc func reviseButtonDidTapped() {
        dismiss(animated: true)
        reviseButtonTappedClosure?()
    }
    
    @objc func setDateButtonDidTapped() {
        print("setDataeButtonTapped")
    }
    
    @objc func setSoonButtonDidTapped() {
        print("soonButtonTapped")
    }
    override func setConstraints() {
        view.addSubviews([todoLabel,todoTypeLabel,mainButtonsStackView,buttonListStackView])
        mainButtonsStackView.addArrangedSubview(reviseButton)
        mainButtonsStackView.addArrangedSubview(deleteButton)
        
        buttonListStackView.addArrangedSubview(setDateButton)
        buttonListStackView.addArrangedSubview(changeToSoonButton)
        todoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        todoTypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(todoLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        mainButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(todoTypeLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        buttonListStackView.snp.makeConstraints { make in
            make.top.equalTo(mainButtonsStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}

private class menuButton: UIControl {
    
    var title = "" {
        didSet{
            titleLabel.text = title
        }
    }
    
    private var iconImageView = UIImageView()
    private var titleLabel = {
        let view = UILabel()
        view.font = Pretendard.size12.medium()
        view.isUserInteractionEnabled = false
        return view
    }()
    private var stackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 15
        view.distribution = .fillProportionally
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage,title: String,tintColor: UIColor) {
        super.init(frame: CGRect())
        iconImageView.image = image
        iconImageView.tintColor = tintColor
        titleLabel.text = title
        setUI()
    }
    private func setUI() {
        isUserInteractionEnabled = true
        addSubview(stackView)
        snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.centerY.horizontalEdges.equalToSuperview()
//            make.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(iconImageView.snp.height)
        }
        
    }
}
