//
//  TimerViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import SwiftUI

import ActivityKit
import SnapKit

class TimerViewController: BaseViewController {
    var timer = Timer()
    var seconds = 1500
    var isTimerRunning = false
    
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
    private let liveActivityButton = {
        let view = UIButton()
        view.setTitle("liveActivity", for: .normal)
        view.tintColor = QColor.accentColor
        view.setTitleColor(QColor.accentColor, for: .normal)
        return view
    }()
    private let endLiveActivityButton = {
        let view = UIButton()
        view.setTitle("EndLiveActivity", for: .normal)
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
        liveActivityButton.addTarget(self, action: #selector(liveActivityButtonDidTap), for: .touchUpInside)
        endLiveActivityButton.addTarget(self, action: #selector(endLiveActivityButtonDidTap), for: .touchUpInside)
        
    }
    private func startLiveActivity() {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let initialContentState = QuokkaWidgetAttributes.ContentState(remainingTimeString: "23:00")
                let activityAttributes = QuokkaWidgetAttributes(todo: "밥먹기")
                let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
                do {
                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
                }
            }
        }
    }
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = QuokkaWidgetAttributes.ContentState(remainingTimeString: "00:00")
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
    @objc private func endLiveActivityButtonDidTap()  {
        Task{ await endLiveActivity() }
    }
    @objc private func startButtonDidTap(){
        if !isTimerRunning{
            isTimerRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            
            startLiveActivity()
        }
        
//        if(isTimerRunning == false){
//            isTimerRunning = true
//
//            timer.invalidate()// 확실하게 다른 타이머 돌아가는게 없도록 하기
    //
//            
//            DispatchQueue.global().async {
//                print(RunLoop.current == RunLoop.main)
//                
//                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                    print(Date())
//                    self.seconds -= 1
//                    DispatchQueue.main.sync{
//                        self.timeLabel.text = self.seconds.timeFormatString
//                    }
//                   
//                    
//                    if(self.seconds == 0){
//                        timer.invalidate()
//                    }
//                }
//                
//                while self.shouldKeepRunning {
//                    RunLoop.current.run(until: .now + 0.1)
//                }
//            }
//        }
       
    }
    @objc private func pauseButtonDidTap(){
        timer.invalidate()
    }
    @objc private func resetButtonDidTap() {
        timer.invalidate()
        isTimerRunning = false
        
        seconds = 1500
        timeLabel.text = seconds.timeFormatString
        
//       await endLiveActivity()
    }
    @objc private func liveActivityButtonDidTap(){
        startLiveActivity()
    }
    
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        timeLabel.text = seconds.timeFormatString
    }
    
    override func setConstraints() {
        view.addSubviews([timeLabel,startButton,pauseButton,resetButton,liveActivityButton,endLiveActivityButton])
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
        }
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(50)
        }
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(10)
        }
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseButton.snp.bottom).offset(10)
        }
        liveActivityButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resetButton.snp.bottom).offset(10)
        }
        endLiveActivityButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(liveActivityButton.snp.bottom).offset(10)
        }
    }
    @objc func timerTimeChanged() {
        seconds -= 1
        timeLabel.text = seconds.timeFormatString
        
        if(seconds == 0){
            timer.invalidate()
        }
    }

}
