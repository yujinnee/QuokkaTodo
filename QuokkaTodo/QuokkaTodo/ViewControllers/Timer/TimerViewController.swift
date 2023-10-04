//
//  TimerViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import SnapKit

extension TimeInterval {
    /// %02d: 빈자리를 0으로 채우고, 2자리 정수로 표현
    var time: String {
        return String(format:"%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}

class TimerViewController: BaseViewController {
    var timer = Timer()
    var seconds = 1500
    
    private let timeLabel = {
        let view = UILabel()
        view.font = Pretendard.size35.bold()
        view.tintColor = QColor.accentColor
        return view
    }()
    private let startButton = {
        let view = UIButton()
        view.setTitle("start", for: .normal)
        view.tintColor = QColor.accentColor
        view.setTitleColor(QColor.accentColor, for: .normal)
        return view
    }()
    private let pauseButton = {
        let view = UIButton()
        view.setTitle("pause", for: .normal)
        view.tintColor = QColor.accentColor
        view.setTitleColor(QColor.accentColor, for: .normal)
        return view
    }()
    private let resetButton = {
        let view = UIButton()
        view.setTitle("reset", for: .normal)
        view.tintColor = QColor.accentColor
        view.setTitleColor(QColor.accentColor, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor
        addTargets()
    }
    private func addTargets(){
        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonDidTap), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        
    }
    @objc private func startButtonDidTap(){
        timer.invalidate()// 확실하게 다른 타이머 돌아가는게 없도록 하기
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
    }
    @objc private func pauseButtonDidTap(){
        timer.invalidate()
    }
    @objc private func resetButtonDidTap(){
        timer.invalidate()
        seconds = 1500
        timeLabel.text = String(getTimeString(sec: seconds))
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        timeLabel.text = seconds.timeFormatString
    }
    
    override func setConstraints() {
        view.addSubviews([timeLabel,startButton,pauseButton,resetButton])
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
        }
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(130)
        }
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(10)
        }
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseButton.snp.bottom).offset(10)
        }
    }
    @objc func timerTimeChanged() {
        seconds -= 1
        timeLabel.text = seconds.timeFormatString
        
        if(seconds == 0){
            timer.invalidate()
        }
    }
    
    private func getTimeString(sec: Int) -> String{
        return String(format:"%02d:%02d",sec/60, sec%60)
    }
    
}
