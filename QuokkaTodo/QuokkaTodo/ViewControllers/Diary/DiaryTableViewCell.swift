//
//  TableViewCell.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/20/23.
//

import UIKit

class DiaryTableViewCell: BaseTableViewCell  {
    
    private let verticalLineView = {
        let view = UIView()
        view.backgroundColor = QColor.grayColor
        return view
    }()
    private let circleView = {
        let view = UIView()
        view.backgroundColor = QColor.subLightColor
        view.layer.cornerRadius = 5
        return view
    }()
    private let dateLabel = {
        let view = UILabel()
        view.text = "01/21"
        view.numberOfLines = 1
        view.font = Pretendard.size14.bold()
        return view
    }()
    private let horizontalLine = {
        let view = UIView()
        view.backgroundColor = QColor.subLightColor
        return view
    }()
    private let diaryLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Pretendard.size14.regular()
        view.lineBreakMode = .byCharWrapping
        view.text = "작업하기 좋은 카페를 발견 했다! 멋진 뷰를 보면서 평화롭게 작업해서 행복했다."
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        contentView.addSubviews([verticalLineView,circleView,dateLabel,horizontalLine,diaryLabel])
        
        verticalLineView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(3)
        }
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(verticalLineView)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(40)
        }
        horizontalLine.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(10)
            make.height.equalTo(1)
        }
        diaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalLine.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(30)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    func setData(item: Diary){

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.contents) ?? Date()
//        dateLabel.text = DateFormatter.convertToOnlyDateDBForm(date: date)
        dateLabel.text = "11.21"
        diaryLabel.text = item.contents
    }
   
}
