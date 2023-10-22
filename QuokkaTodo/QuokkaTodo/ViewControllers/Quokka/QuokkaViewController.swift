//
//  QuokkaViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit

class QuokkaViewController: BaseViewController {
    let levelRepository = LevelRepository()
    let bagRepository = BagRepository()
    let feedLeafRepository = FeedLeafRepository()
    let feedNutritionRepository = FeedNutritionRepository()
    
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
        view.setImage(UIImage(systemName: "tshirt"), for: .normal)
        view.configuration = brownButtonConfiguration
        return view
    }()
    private lazy var diaryButton = {
        let view = UIButton()
        view.configuration = brownButtonConfiguration
        view.configuration?.attributedTitle = AttributedString("행복일기", attributes: titleContainer)
        return view
    }()
    private let quokkaImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Costume.none.quokkaImage)
        return view
    }()
    private let levelLabel = {
        let view = UILabel()
        view.text = "Lv.12"
        view.font = Pretendard.size23.black()
        view.textColor = QColor.subDeepColor
        return view
    }()
    private let progressBarView = {
        let view = UIProgressView()
        view.progressViewStyle = .default
        view.progressTintColor = QColor.accentColor
        view.trackTintColor = QColor.grayColor
        view.progress = 0.0
//        view.transform = view.transform.scaledBy(x: 1, y: 8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.sublayers![1].cornerRadius = 5
        view.subviews[1].clipsToBounds = true
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
        addTargets()
        view.backgroundColor = QColor.backgroundColor
        setExpProgressBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLeafNum()
        fetchLevelAndExp()
        print(#function)
        setQuokkaImage()
    }
    func setQuokkaImage() {
        var idx = UserDefaultsHelper.standard.selectedCostume
        let imageName = Costume(rawValue: idx)?.quokkaImage ?? ""
        
        quokkaImageView.image = UIImage(named: imageName) ?? UIImage()
    }
    func setExpProgressBar() {
        let (_,exp) = getLevelAndExp()
        progressBarView.progress = Float(exp/100)
    }
    
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_barchart") , style: .plain, target: self, action: #selector(chartButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = QColor.accentColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_settinggear") , style: .plain, target: self, action: #selector(settingButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = QColor.accentColor
        
        navigationController?.navigationBar.tintColor = QColor.accentColor

    }
    private func addTargets(){
        feedLeafButton.addTarget(self, action: #selector(feedLeafButtonTapped), for: .touchUpInside)
        feedNutritionButton.addTarget(self, action: #selector(feedNutritionButtonTapped), for: .touchUpInside)
        costumeButton.addTarget(self, action: #selector(costumeButtonTapped), for: .touchUpInside)
        diaryButton.addTarget(self, action: #selector(diaryButtonTapped), for: .touchUpInside)
    }
    private func getLevelAndExp() -> (level:Int,exp:Double){
        let feedLeafNum = levelRepository.readLeafNum()
        let feedNutritionNum = levelRepository.readNutritionNum()
        let sum = Double(feedLeafNum)*3.323 + Double(feedNutritionNum)*6.216
        let level = Int(sum/100)
        let exp = Double(sum).truncatingRemainder(dividingBy: 100)
        return(level,exp)
    }
    func fetchLevelAndExp(){
        let (level,exp) = getLevelAndExp()
        levelLabel.text = "Lv.\(level)"
        expLabel.text = "\(String(format: "%.2f",exp))%"
    }
    @objc private func feedLeafButtonTapped(){
        let bagLeafNum = bagRepository.readLeafNum() - 1
        if(bagLeafNum<0) {return}
        bagRepository.updateLeafNum(num: bagLeafNum)
        
        var feedLeafNum = levelRepository.readLeafNum() + 1
        feedLeafRepository.createFeedLeaf(FeedLeaf(feedLeafTime: DateFormatter.convertToFullDateDBForm(date: Date())))
        
        levelRepository.updateLeafNum(num: feedLeafNum)
       
        let (_,exp) = getLevelAndExp()
        animateProgressBar(progress: Float(exp/100))
        fetchLeafNum()
        fetchLevelAndExp()
        
        leafLabel.text = "쿼카에게 줄 수 있는 나뭇잎 \(bagLeafNum)개"
       
    }
    private func animateProgressBar(progress:Float){
        UIView.animate(withDuration: 1) {
            self.progressBarView.setProgress(progress, animated: true)
        }
    }
    @objc private func feedNutritionButtonTapped(){
        let vc = DiaryWritingViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.diaryWritingCompletedCompletion = {
            self.fetchLevelAndExp()
            print("DDD")
            let (_,exp) = self.getLevelAndExp()
            self.animateProgressBar(progress: Float(exp/100))
        }

        present(vc, animated: true)
    }
    @objc private func costumeButtonTapped() {
        let vc = CostumeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func diaryButtonTapped() {
        let vc = DiaryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func chartButtonTapped(){
        let vc = ChartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func settingButtonTapped(){
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func fetchLeafNum(){
        leafLabel.text = "쿼카에게 줄 수 있는 나뭇잎 \(bagRepository.readLeafNum()) 개"
    }
                                    
    override func setConstraints() {
        view.addSubviews([diaryButton,costumeButton,quokkaImageView,levelLabel,progressBarView,expLabel,leafLabel,feedLeafButton,feedNutritionButton])
        diaryButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalToSuperview().inset(30)
        }
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
        progressBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(16)
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
        }
        expLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(progressBarView.snp.bottom).offset(10)
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
