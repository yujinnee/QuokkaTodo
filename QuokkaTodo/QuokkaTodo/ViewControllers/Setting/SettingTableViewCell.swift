//
//  SettingTableViewCell.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/23/23.
//

import UIKit

class SettingTableViewCell: BaseTableViewCell {
    let titleLabel = {
        let view = UILabel()
        view.font = Pretendard.size16.medium()
        view.textColor = QColor.fontColor
        return view
    }()
    let chevronImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .systemGray
        return view
    }()
    let versionLabel = {
        let view = UILabel()
        view.text = "v1.0.2"
        view.font = Pretendard.size14.medium()
        view.textColor = QColor.fontColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setConstraints() {
        contentView.addSubviews([titleLabel,chevronImage,versionLabel])
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        chevronImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.width.equalTo(chevronImage.snp.height)
        }
        versionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    func setTitle(title: String){
        titleLabel.text = title
    }
    func setVersionLabel(){
        chevronImage.isHidden = true
        versionLabel.isHidden = false
        
    }
    func setChevronButton(){
        chevronImage.isHidden = false
        versionLabel.isHidden = true
    }


    
}
