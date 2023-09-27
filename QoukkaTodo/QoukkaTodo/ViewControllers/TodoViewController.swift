//
//  TodoViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit

class TodoViewController: BaseViewController {
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = QColor.accentColor
        label.font = Pretendard.size20.bold()
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor
        let month = 1
        let day = 16
        
        dateLabel.text = "date_text".localized(num1: month, num2: day)

        
    }
    
    override func setConstraints() {
        view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    


}
