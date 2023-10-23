//
//  ToastMessageView.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/23/23.
//

import UIKit

class ToastMessageView: UIView{
        
    private let messageText: UILabel = {
        let view = UILabel()
        view.font = Pretendard.size13.regular()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        clipsToBounds = true
        layer.cornerRadius = 10
        messageText.text = message
        addSubview(messageText)
        messageText.snp.makeConstraints{
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
}

