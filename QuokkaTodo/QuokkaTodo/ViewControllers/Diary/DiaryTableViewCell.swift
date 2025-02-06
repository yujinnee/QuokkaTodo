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
        view.font = Pretendard.size14.regular()
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
        view.font = Pretendard.size14.light()
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
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(3)
        }
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.top.equalToSuperview().offset(13)
            make.centerX.equalTo(verticalLineView)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.centerY.equalTo(circleView)
            make.width.greaterThanOrEqualTo(40)
        }
        horizontalLine.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.centerY.equalTo(dateLabel)
            make.width.equalTo(10)
            make.height.equalTo(1)
        }
        diaryLabel.snp.makeConstraints { make in
            make.leading.equalTo(horizontalLine.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    override func prepareForReuse() {
        diaryLabel.text = nil
        verticalLineView.backgroundColor = QColor.grayColor
        verticalLineView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(3)
        }
    }
    func setData(item: Diary,isFirst: Bool,isLast: Bool ){
        designGrayline(isFirst: isFirst, isLast: isLast)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateLabel.text = DateFormatter.convertFromDateToDiaryString(date: item.createdDate)
        diaryLabel.text = item.contents
    }
    private func designGrayline(isFirst: Bool, isLast: Bool){
        if isFirst {
            verticalLineView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(13)
                make.bottom.equalToSuperview()
                make.leading.equalToSuperview().inset(20)
                make.width.equalTo(3)
            }
        }
        if isLast {
            verticalLineView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(13)
                make.leading.equalToSuperview().inset(20)
                make.width.equalTo(3)
            }
        }
    }
   
}
