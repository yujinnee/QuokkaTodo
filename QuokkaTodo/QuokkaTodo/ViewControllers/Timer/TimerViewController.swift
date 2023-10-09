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
    var seconds:Double = 1500
    var isTimerRunning = false
    var isPaused = false
    var startTime = Date()
    var endTime =  Date()
    var leftTimeInterval: TimeInterval = 1500
    let onePomoInterval:TimeInterval = 25*60
    let selectedTodo = "코딩하기"
   
    
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
//    private let liveActivityButton = {
//        let view = UIButton()
//        view.setTitle("liveActivity", for: .normal)
//        view.tintColor = QColor.accentColor
//        view.setTitleColor(QColor.accentColor, for: .normal)
//        return view
//    }()
//    private let endLiveActivityButton = {
//        let view = UIButton()
//        view.setTitle("EndLiveActivity", for: .normal)
//        view.tintColor = QColor.accentColor
//        view.setTitleColor(QColor.accentColor, for: .normal)
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor
        addTargets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        if(endTime.compare(.now) == .orderedAscending) {// 시간 지났을 때
            seconds = 1500
            timeLabel.text = seconds.timeFormatString
        }else{
            leftTimeInterval = endTime.timeIntervalSince(.now)
            seconds = leftTimeInterval
            timeLabel.text = seconds.timeFormatString
        }
        
    }

    private func addTargets(){
        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonDidTap), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
//        liveActivityButton.addTarget(self, action: #selector(liveActivityButtonDidTap), for: .touchUpInside)
//        endLiveActivityButton.addTarget(self, action: #selector(endLiveActivityButtonDidTap), for: .touchUpInside)
        
    }
   
    @objc private func startButtonDidTap(){
        if !isPaused{// 첫 시작
            isTimerRunning = true
            startTime = Date.now
            endTime = Date(timeInterval: onePomoInterval, since: startTime)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            
            startLiveActivity()
            
        }else {//일시 정지 했다가 재시작
            isTimerRunning = true
            isPaused = false
            startTime = Date.now
            endTime = Date.now.addingTimeInterval(leftTimeInterval)
            seconds = leftTimeInterval
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            Task{
                await restartTimerIntLiveActivity()
            }
            
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
        if(isTimerRunning){
            timer.invalidate()
            isTimerRunning = false
            isPaused = true
            leftTimeInterval = endTime.timeIntervalSince(Date.now) + 1 //다시 시작할때 초가 자꾸 튀어서 1초 더해서 저장함..
            Task{ await pauseLiveActivity()}
        }
       
    }
    @objc private func resetButtonDidTap() {
        if isTimerRunning{
            Task{ await endLiveActivity()}
        }
        timer.invalidate()
        isTimerRunning = false
        isPaused = false
        
        seconds = 1500
        leftTimeInterval = 1500
        timeLabel.text = seconds.timeFormatString
        
       
    }
    @objc private func liveActivityButtonDidTap(){
        startLiveActivity()
    }
    @objc private func endLiveActivityButtonDidTap()  {
        Task{ await endLiveActivity() }
    }
    
    private func startLiveActivity() {
        if #available(iOS 16.2, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let initialContentState = QuokkaWidgetAttributes.ContentState(todo: selectedTodo, seconds: leftTimeInterval, isPaused: false)
                let activityAttributes = QuokkaWidgetAttributes()
                let activityContent = ActivityContent(state: initialContentState, staleDate: nil)
                do {
                    let activity = try Activity.request(attributes: activityAttributes, content: activityContent)
                    print("Requested Lockscreen Live Activity(Timer) \(String(describing: activity.id)).")
                } catch (let error) {
                    print("Error requesting Lockscreen Live Activity(Timer) \(error.localizedDescription).")
                }
            }
        }
    }
    private func pauseLiveActivity() async {
        if #available(iOS 16.2, *) {
            let updateStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodo,seconds: leftTimeInterval, isPaused: true)
            let updateContent = ActivityContent(state: updateStatus, staleDate: nil)

            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.update(updateContent)
                print("Updating the Live Activity(forPause): \(activity.id)")
            }
        }
    }
    private func restartTimerIntLiveActivity() async {
        if #available(iOS 16.2, *) {
            let updateStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodo,seconds: leftTimeInterval, isPaused: false)
            let updateContent = ActivityContent(state: updateStatus, staleDate: nil)

            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.update(updateContent)
                print("Updating the Live Activity(Timer): \(activity.id)")
            }
        }
    }
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodo, seconds: TimeInterval(), isPaused: true)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)

            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
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
            make.centerY.equalTo(pauseButton)
            make.trailing.equalTo(pauseButton.snp.leading).offset(-60)
        }
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(100)
        }
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(pauseButton)
            make.leading.equalTo(pauseButton.snp.trailing).offset(60)
        }
//        liveActivityButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(resetButton.snp.bottom).offset(10)
//        }
//        endLiveActivityButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(liveActivityButton.snp.bottom).offset(10)
//        }
    }
    @objc func timerTimeChanged() {
        seconds -= 1
        timeLabel.text = seconds.timeFormatString
        
        if(seconds == 0){
            timer.invalidate()
        }
    }

}
