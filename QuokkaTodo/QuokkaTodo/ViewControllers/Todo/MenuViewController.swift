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
    let spareTodoRepository = SpareTodoRepository()
    var todoType: TodoType?
    var deleteButtonTappedClosure: (()->Void)?
    var reviseButtonTappedClosure: (()->Void)?
    
    var _id: ObjectId?
    
    private let todoLabel = {
        let view = UILabel ()
        view.text = "투두제목"
        view.textAlignment = .center
        view.font = Pretendard.size20.bold()
        return view
    }()
    private let todoTypeLabel = {
        let view = UILabel ()
        view.textAlignment = .center
        view.textColor = QColor.accentColor
        view.font = Pretendard.size11.medium()
        return view
    }()
    let buttonStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    private let reviseButton = {
        let view = UIButton()
        view.setTitle("수정", for: .normal)
        view.setImage(UIImage(systemName: "pencil"), for: .normal)
        view.titleLabel?.font = Pretendard.size18.bold()
        view.setTitleColor(QColor.accentColor, for: .normal)
        view.tintColor = QColor.accentColor
        view.layer.cornerRadius = 10
        view.layer.borderColor = QColor.accentColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let deleteButton = {
        let view = UIButton()
        view.setTitle("삭제", for: .normal)
        view.setImage(UIImage(systemName: "trash"), for: .normal)
        view.titleLabel?.font = Pretendard.size18.bold()
        view.setTitleColor(QColor.accentColor, for: .normal)
        view.tintColor = QColor.accentColor
        view.layer.cornerRadius = 10
        view.layer.borderColor = QColor.accentColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
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
        case .soon:
            todoTypeLabel.text = "곧 할 일"
        case .today:
            todoTypeLabel.text = "오늘 할 일"
        default :
            break
        }
        
    }
    private func setTodoLabel() {
        guard let _id = _id else {return}
        switch todoType {
        case .soon:
            todoLabel.text = spareTodoRepository.readTodo(_id: _id).contents
        case .today:
            todoLabel.text = todoRepository.readTodo(_id: _id).contents
        default :
            break
        }
        
    }
    private func addTargets(){
        deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        reviseButton.addTarget(self, action: #selector(reviseButtonDidTapped), for: .touchUpInside)
    }
    @objc func deleteButtonDidTapped() {
        switch todoType{
        case .soon:
            spareTodoRepository.deleteTodo(_id: _id ?? ObjectId())
        case .today:
            todoRepository.deleteTodo(_id: _id ?? ObjectId())
        default:
            break
        }
        dismiss(animated: true)
        deleteButtonTappedClosure?()
    }
    
    @objc func reviseButtonDidTapped() {
        dismiss(animated: true)
        reviseButtonTappedClosure?()
    }
    override func setConstraints() {
        view.addSubviews([todoLabel,todoTypeLabel,buttonStackView])
        buttonStackView.addArrangedSubview(reviseButton)
        buttonStackView.addArrangedSubview(deleteButton)
        todoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview()
        }
        todoTypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(todoLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(todoTypeLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
    }
    
}
