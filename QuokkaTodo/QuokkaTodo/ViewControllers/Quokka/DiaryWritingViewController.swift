//
//  DiaryWritingViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/18/23.
//

import UIKit

class DiaryWritingViewController: UIViewController {
    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()
    private let popupView = {
        let view = UIView()
        view.backgroundColor = QColor.backgroundColor
        return view
    }()
    private let diaryDecisionLabel = {
        let view = UILabel()
        view.text = "오늘의 행복일기 한 줄을 작성해주세요. 헹복일기는 영양제가 되어 쿼카가 더 잘 자라게 해준답니다."
        return view
    }()
    private let subDecisionLabel = {
        let view = UILabel()
        view.text = "작성해주신 행복일기는 쿼카가 잘 가지고 있다가 연말에 모아서 보여드립니다!"
        return view
    }()
    
    private let diaryTextfield = {
        let view = UITextField()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
