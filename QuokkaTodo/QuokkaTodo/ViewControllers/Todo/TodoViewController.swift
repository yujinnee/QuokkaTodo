//
//  TodoViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import FSCalendar

class TodoViewController: BaseViewController{
    private let headerLabel = {
        let view  = UILabel()
        view.textColor = QColor.accentColor
        view.font = DINPro.size23.bold()
        let now = Date()
        view.text = DateFormatter.getYearMonth(date: now)
        return view
    }()
    
    private let calendarView = {
        let view = FSCalendar()
        view.tintColor = QColor.accentColor
        view.allowsSelection = true
        return view
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = QColor.accentColor
        label.font = Pretendard.size20.semibold()
        let now = Date()
//        let currentMonth = Calendar.current.component(.month, from:now)
//        let currentDay = Calendar.current.component(.day, from:now)
        label.text = DateFormatter.getMonthDayWeekDay(date: now)
        return label
    }()
    
    private lazy var todoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = CGFloat(16)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.bounces = true
        view.backgroundColor = .none
        view.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
        view.register(TodoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoHeaderView.identifier)
        return view
    }()
    private let textFieldBackgroundView = {
        let view = UIView()
        view.backgroundColor = QColor.backgroundColor
        return view
    }()
    private let textFieldBorderview = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = QColor.accentColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let registerButton = {
        let view = UIButton()
        view.setTitleColor(QColor.accentColor, for: .normal)
        view.setTitle("추가", for: .normal)
        view.titleLabel?.font = Pretendard.size18.bold()
        return view
    }()
    private let textField = {
        let view = UITextField()
        view.isHidden = false
        view.borderStyle = .none
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        configureView()
        setCalendarView()
      
        setDelegate()
       
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        view.backgroundColor = QColor.backgroundColor
//        let month = 1
//        let day = 16
//        dateLabel.text = "date_text".localized(num1: month, num2: day)
    }
   
    
    override func setConstraints() {
        view.addSubviews([headerLabel,calendarView,dateLabel,todoCollectionView,textFieldBackgroundView])
        textFieldBackgroundView.addSubviews([textFieldBorderview,registerButton])
        textFieldBorderview.addSubview(textField)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        todoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        textFieldBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            make.height.equalTo(48)
        }
        textFieldBorderview.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(registerButton.snp.leading).offset(-10)
        }
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        registerButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    
    }
    
    func setDelegate(){
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
    }


}

extension TodoViewController:  FSCalendarDelegate, FSCalendarDataSource {
    func setCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.select(calendarView.today)
        calendarView.weekdayHeight = 48
    
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.scope = .month
        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .horizontal
        
        calendarView.appearance.weekdayFont = DINPro.size13.medium()
        calendarView.appearance.weekdayTextColor = QColor.accentColor
        
        calendarView.appearance.titleFont = DINPro.size11.regular()
        
        calendarView.headerHeight = 0
//        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendarView.appearance.selectionColor = QColor.accentColor
        calendarView.appearance.todayColor = .black
        
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        print(dateFormatter.string(from:date) + "날짜가 선택 되었습니다.")
    }

}

extension TodoViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell()}
        cell.setData(todo: "밥먹기")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoHeaderView.identifier, for: indexPath) as? TodoHeaderView else {return UICollectionReusableView()}
        switch indexPath.section {
        case 0:
            header.setTitle(text: "곧 할 일")
            header.addButtonComletionHandler = {
                print("addButtonTapped")
               
            }
        case 1:
            header.setTitle(text: "오늘 할 일")
        default:
            break
        }
        return header
    }
    
}
extension TodoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width-40, height: 40)
    }
}
