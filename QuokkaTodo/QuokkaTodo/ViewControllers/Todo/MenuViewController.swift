//
//  MenuViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 2023/10/01.
//

import UIKit

class MenuViewController: BaseViewController {
    private let todoLabel = {
        let view = UILabel ()
        view.text = "투두제목"
        view.textAlignment = .center
        view.font = Pretendard.size20.bold()
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
        
    }
    override func setConstraints() {
        view.addSubviews([todoLabel,buttonStackView])
        buttonStackView.addArrangedSubview(reviseButton)
        buttonStackView.addArrangedSubview(deleteButton)
        todoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(todoLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
//        reviseButton.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalToSuperview().offset(50)
//            make.height.equalTo(44)
//        }
//        deleteButton.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalTo(reviseButton.snp.bottom)
//            make.height.equalTo(44)
//        }
    }
    
}
