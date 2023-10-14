//
//  QuokkaViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit

class QuokkaViewController: BaseViewController {
    
    private let brownButtonConfiguration = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = QColor.accentColor
        config.baseForegroundColor = QColor.backgroundColor
        return config
    }()
    private let titleContainer = {
        var container = AttributeContainer()
        container.font = Pretendard.size18.medium()
        return container
    }()
    
    private lazy var costumeButton = {
        let view = UIButton()
        view.configuration = brownButtonConfiguration
        view.configuration?.attributedTitle = AttributedString("꾸미기", attributes: titleContainer)
        return view
    }()
    private let quokkaImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "img_quokka")
        return view
    }()
    private let levelLabel = {
        let view = UILabel()
        view.text = "LV.12"
        view.font = Pretendard.size13.bold()
        view.textColor = QColor.subDeepColor
        return view
    }()
    private let expLabel = {
        let view = UILabel()
        view.text = "77.7%"
        view.font = Pretendard.size13.bold()
        view.textColor = QColor.subDeepColor
        return view
    }()
    private let leafLabel = {
        let view = UILabel()
        view.text = "나뭇잎 23개"
        view.font = Pretendard.size13.bold()
        view.textColor = QColor.subDeepColor
        return view
    }()
   
    private lazy var feedLeafButton = {
        let view = UIButton()
        view.configuration = brownButtonConfiguration
        view.configuration?.attributedTitle = AttributedString("나뭇잎 먹이기", attributes: titleContainer)
        return view
    }()
    private lazy var feedNutritionButton = {
        let view = UIButton()
        view.configuration = brownButtonConfiguration
        view.configuration?.attributedTitle = AttributedString("행복 영양제 먹이기", attributes: titleContainer)
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor


        // Do any additional setup after loading the view.
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_barchart") , style: .plain, target: self, action: #selector(chartButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = QColor.accentColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_settinggear") , style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = QColor.accentColor
        
       
    
        navigationController?.navigationBar.tintColor = QColor.accentColor

    }
    @objc private func chartButtonTapped(){
        let vc = ChartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func settingButtonTapped(){
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
                                                           
    override func setConstraints() {
        view.addSubviews([costumeButton,quokkaImageView,levelLabel,expLabel,leafLabel,feedLeafButton,feedNutritionButton])
        costumeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.trailing.equalToSuperview().inset(30)
        }
        quokkaImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0/2.0)
            make.height.equalTo(quokkaImageView.snp.width).multipliedBy(250.0/177.0)

        }
        levelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(quokkaImageView.snp.bottom).offset(10)
        }
        expLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
        }
        leafLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(expLabel.snp.bottom).offset(20)
        }
        feedLeafButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(leafLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            
        }
        feedNutritionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(feedLeafButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            
        }
        
        
    }

}
