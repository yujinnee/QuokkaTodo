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
import RealmSwift

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
enum TimerStatus: Int {
    case reset = 0
    case running = 1
    case pause = 2
}

class TimerViewController: BaseViewController {
    var timer = Timer()
    let todoRepository = TodoRepository()
    var leftTimeInterval = TimeInterval()
    let onePomoInterval:TimeInterval = 60*25
    var todoType: TodoType = .todayTodo
    var selectedTodoId: ObjectId?
    var selectedTodoContents = "" {
        didSet{
            todoSelectionButton.setTitle(selectedTodoContents, for: .normal)
        }
    }
    let timeUnit = 0.01
    var timerStatus:TimerStatus = .reset {
        didSet{
            setButton(status: timerStatus)
        }
    }
    private let todoSelectionButton = {
        let view = UIButton()
        view.setTitle("투두 선택하기", for: .normal)
        view.layer.borderColor = QColor.grayColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 8
        view.setTitleColor(QColor.fontColor, for: .normal)
        view.titleLabel?.font = Pretendard.size15.bold()
        view.titleLabel?.lineBreakMode = .byTruncatingTail
        return view
    }()
    private let timeLabel = {
        let view = UILabel()
        view.font = Pretendard.size35.bold()
        return view
    }()
    private lazy var circularProgressView = {
        let view = CircularProgressView(seconds:leftTimeInterval,onePomo: onePomoInterval,frame: CGRect(x: 0, y: 0, width: view.frame.width-80, height: view.frame.width-80))
        return view
    }()
    private let startButton = {
        let view = UIButton()
        view.setTitle("뽀모도로 시작하기", for: .normal)
        view.setTitleColor(QColor.backgroundColor, for: .normal)
        view.titleLabel?.font = Pretendard.size18.medium()
        view.backgroundColor = QColor.accentColor
        view.layer.cornerRadius = 8
        return view
    }()
    private let pauseButton = {
        let view = UIButton()
        view.setTitle("일시정지", for: .normal)
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = Pretendard.size18.medium()
        view.backgroundColor = QColor.subLightColor
        view.layer.cornerRadius = 8
        
        return view
    }()
    private let resetButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
        view.tintColor = .systemGray2
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray2.cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor
        addTargets()
        addLifeCycleObserver()
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        timeLabel.text = leftTimeInterval.timeFormatString
    }
    private func initTimer() {
        leftTimeInterval = UserDefaultsHelper.standard.leftTimeInterval
    }

    private func setButton(status: TimerStatus){
        switch status{
        case .running:
            startButton.isHidden = true
            pauseButton.isHidden = false
            resetButton.isHidden = false
        case .pause:
            startButton.setTitle("다시 시작하기", for: .normal)
            startButton.isHidden = false
            pauseButton.isHidden = true
            resetButton.isHidden = false
        case .reset:
            startButton.setTitle("뽀모도로 시작하기", for: .normal)
            startButton.isHidden = false
            pauseButton.isHidden = true
            resetButton.isHidden = true
            
        }
    }
    private func addTargets(){
        todoSelectionButton.addTarget(self, action: #selector(todoSelectionButtonDidTap), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonDidTap), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
    }
    @objc func todoSelectionButtonDidTap() {
        let todoSelectionViewController = TodoSelectionViewController()
        todoSelectionViewController.modalPresentationStyle = .pageSheet
        todoSelectionViewController.todoCellTappedClosure = { _id ,todoType in
            
            self.selectedTodoId = _id
            UserDefaultsHelper.standard.selectedTodo = _id.stringValue
            
            self.todoType = todoType
            
            let item = self.todoRepository.readTodo(_id:self.selectedTodoId ?? ObjectId())
            self.selectedTodoContents = item.contents
            Task{await self.updateTodoLiveActivity()}
            
        }
        self.present(todoSelectionViewController, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        setTimerProcess()
    }
    private func setTimerProcess() {
        
        guard let endTime = DateFormatter.convertFromStringToDate(date: UserDefaultsHelper.standard.endTime ?? "") else {//돌려놓은 타이머가 없을 때
            timerStatus = .reset
            setButton(status: .reset)
            leftTimeInterval = onePomoInterval
            selectedTodoId = nil
            self.selectedTodoContents = "투두 선택하기"
            Task{ await endLiveActivity()}
            timeLabel.text = leftTimeInterval.timeFormatString
            return
        }
        let isPause = UserDefaultsHelper.standard.isPause
        if(isPause == true){// 정지 되어있는 상태
            timerStatus = .pause
            setButton(status: .pause)
            let leftTimeInterval = UserDefaultsHelper.standard.leftTimeInterval
            print("viewWillPause\(leftTimeInterval)")
            self.leftTimeInterval = leftTimeInterval
            circularProgressView.progress = leftTimeInterval/onePomoInterval
            circularProgressView.setPauseStatus()
            timer.invalidate()
            timeLabel.text = leftTimeInterval.timeFormatString
            do {
                selectedTodoId = try ObjectId(string: UserDefaultsHelper.standard.selectedTodo)
            } catch {
                print(error)
            }
            let item = self.todoRepository.readTodo(_id:self.selectedTodoId ?? ObjectId())
            self.selectedTodoContents = item.contents
            
        }
        else if(endTime.compare(.now) == .orderedAscending || endTime.compare(.now) == .orderedSame) {// 타이머 돌려놓은 상태이고 시간 지났을 때
            timerStatus = .reset
            setButton(status: .reset)
            do {
                selectedTodoId = try ObjectId(string: UserDefaultsHelper.standard.selectedTodo)
            } catch {
                print(error)
            }
            let item = self.todoRepository.readTodo(_id:self.selectedTodoId ?? ObjectId())
            self.selectedTodoContents = item.contents
            if(selectedTodoId != nil){
                todoRepository.updateLeaves(_id: selectedTodoId ?? ObjectId(), leaf: Leaf(gainLeafTime: Date()))
            }
            
            leftTimeInterval = onePomoInterval
            timeLabel.text = leftTimeInterval.timeFormatString
            Task{ await endLiveActivity()}
            
        }
        else{ // 달리고 있을 떄
            timerStatus = .running
            leftTimeInterval = endTime.timeIntervalSince(.now)
            timeLabel.text = leftTimeInterval.timeFormatString
            timer = Timer.scheduledTimer(timeInterval: timeUnit, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            do {
                selectedTodoId = try ObjectId(string: UserDefaultsHelper.standard.selectedTodo)
            } catch {
                print(error)
            }
            let item = self.todoRepository.readTodo(_id:self.selectedTodoId ?? ObjectId())
            self.selectedTodoContents = item.contents
        }
    }
    private func addLifeCycleObserver(){
        //옵저버 등록
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc func didEnterBackground() {
        print("didEnterBackgroud")
        timer.invalidate()
    }
        
    //앱 foreground시 호출
    @objc func willEnterForeground() {
        print("willEnterForeground")
        setTimerProcess()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        timer.invalidate()
        NotificationCenter.default.removeObserver(self)

    }
    
    @objc private func startButtonDidTap(){
        guard let _ = selectedTodoId else {
            view.makeToastAnimation(message: "투두를 선택 해 주세요")
            return
        }
        
        if timerStatus == .reset {// 첫 시작
            timerStatus = .running
            leftTimeInterval = onePomoInterval
            let endTime = Date(timeInterval: onePomoInterval, since: Date.now)
            UserDefaultsHelper.standard.endTime = DateFormatter.convertFromDateToString(date:endTime)
            
            timer = Timer.scheduledTimer(timeInterval: timeUnit, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            startLiveActivity()
        }else if timerStatus == .pause{//일시 정지 했다가 재시작
            timerStatus = .running
            
            let endTime = Date.now.addingTimeInterval(leftTimeInterval)
            UserDefaultsHelper.standard.endTime = DateFormatter.convertFromDateToString(date:endTime)
            
            timer = Timer.scheduledTimer(timeInterval: timeUnit, target: self, selector: #selector(timerTimeChanged), userInfo: nil, repeats: true)
            Task{
                await restartTimerInLiveActivity()
            }
            UserDefaultsHelper.standard.isPause = false
            
        }
        circularProgressView.progress = leftTimeInterval/onePomoInterval
        
        
    }
    @objc private func pauseButtonDidTap(){
        timerStatus = .pause
        let endTime = DateFormatter.convertFromStringToDate(date: UserDefaultsHelper.standard.endTime ?? "") ?? Date()
        print("pauseEndtime\(endTime)")
        leftTimeInterval = endTime.timeIntervalSince(Date.now)
        print("pauseLfetTimeInterval\(leftTimeInterval)")
        
        UserDefaultsHelper.standard.leftTimeInterval = leftTimeInterval
        UserDefaultsHelper.standard.isPause = true
        
        timer.invalidate()
        Task{ await pauseLiveActivity()}
        circularProgressView.setPauseStatus()
        
    }
    @objc private func resetButtonDidTap() {
        let alert = UIAlertController(title: "뽀모도로 초기화", message: "측정 중인 시간이 사라지게 됩니다. 초기화 하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.setReset()
        }
        cancel.setValue(QColor.accentColor, forKey: "titleTextColor")
        ok.setValue(QColor.accentColor, forKey: "titleTextColor")
        
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
    private func setReset() {
        timerStatus = .reset
        UserDefaultsHelper.standard.endTime = nil
        UserDefaultsHelper.standard.isPause = false
        leftTimeInterval = onePomoInterval
        Task{ await endLiveActivity()}
        timer.invalidate()
        timeLabel.text = leftTimeInterval.timeFormatString
        circularProgressView.resetStatus()
    }
    
    @objc func timerTimeChanged() {
        if(leftTimeInterval <= 0){
            view.makeToastAnimation(message: "뽀모도로를 완료하여 나뭇잎 1개를 \n획득하였습니다!🌱")
            circularProgressView.setEndStatus()
            timer.invalidate()
            timeLabel.text = 0.timeFormatString
            
            let leaf = Leaf(gainLeafTime: Date())
            print(selectedTodoId)
            if(selectedTodoId != nil){
                todoRepository.updateLeaves(_id: selectedTodoId ?? ObjectId(), leaf: leaf)
            }
            setReset()
        }
        else{
            leftTimeInterval -= timeUnit
            timeLabel.text = leftTimeInterval.timeFormatString
            circularProgressView.progress = leftTimeInterval/onePomoInterval

        }
        
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
                let initialContentState = QuokkaWidgetAttributes.ContentState(todo: selectedTodoContents, seconds: leftTimeInterval, isPaused: false)
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
            let updateStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodoContents,seconds: leftTimeInterval, isPaused: true)
            let updateContent = ActivityContent(state: updateStatus, staleDate: nil)
            
            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.update(updateContent)
                print("Updating the Live Activity(forPause): \(activity.id)")
            }
        }
    }
    private func restartTimerInLiveActivity() async {
        if #available(iOS 16.2, *) {
            let updateStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodoContents,seconds: leftTimeInterval, isPaused: false)
            let updateContent = ActivityContent(state: updateStatus, staleDate: nil)
            
            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.update(updateContent)
                print("Updating the Live Activity(Timer): \(activity.id)")
            }
        }
    }
    private func updateTodoLiveActivity() async {
        if #available(iOS 16.2, *) {
            let updateStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodoContents,seconds: leftTimeInterval, isPaused: false)
            let updateContent = ActivityContent(state: updateStatus, staleDate: nil)
            
            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.update(updateContent)
                print("Updating the Live Activity(Timer): \(activity.id)")
            }
        }
    }
    private func endLiveActivity() async {
        if #available(iOS 16.2, *) {
            let finalStatus = QuokkaWidgetAttributes.ContentState(todo: selectedTodoContents, seconds: TimeInterval(), isPaused: true)
            let finalContent = ActivityContent(state: finalStatus, staleDate: nil)
            
            for activity in Activity<QuokkaWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending the Live Activity(Timer): \(activity.id)")
            }
        }
    }
    
    
    
    override func setConstraints() {
        view.addSubviews([todoSelectionButton,circularProgressView,startButton,pauseButton,resetButton])
        circularProgressView.addSubview(timeLabel)
        
        todoSelectionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(35)
        }
        circularProgressView.snp.makeConstraints{ make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(circularProgressView.snp.width)
        }
        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(circularProgressView.snp.bottom).offset(30)
        }
        pauseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.top.equalTo(circularProgressView.snp.bottom).offset(30)
        }
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(circularProgressView.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    
}
