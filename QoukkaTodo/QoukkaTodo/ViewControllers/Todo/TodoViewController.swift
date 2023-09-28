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
        view.font = Pretendard.size26.bold()
        return view
    }
    
    private let calendarView = {
        let view = FSCalendar()
        view.tintColor = QColor.accentColor
        view.allowsSelection = true
        return view
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = QColor.accentColor
        label.font = Pretendard.size20.bold()
        return label
    }()
    
    private lazy var todoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = CGFloat(16)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 50)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.bounces = true
        view.backgroundColor = .none
        view.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = QColor.backgroundColor
        let month = 1
        let day = 16
        setCalendarView()
        dateLabel.text = "date_text".localized(num1: month, num2: day)
        setDelegate()
       
    }
   
    
    override func setConstraints() {
        view.addSubview(calendarView)
        view.addSubview(dateLabel)
        view.addSubview(todoCollectionView)
        calendarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        todoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
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
        
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.scope = .month
        calendarView.scrollEnabled = false
        calendarView.scrollDirection = .horizontal
        
        calendarView.appearance.weekdayFont = Pretendard.size13.medium()
        calendarView.appearance.weekdayTextColor = QColor.accentColor
        
        calendarView.appearance.titleFont = Pretendard.size11.light()
        
        calendarView.headerHeight = 0
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
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
}
