//
//  TodoViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import FSCalendar
import RealmSwift

enum TodoType{
    case soon
    case today
}
class TodoViewController: BaseViewController{
    let todoRepository = TodoRepository()
    let spareTodoRepository = SpareTodoRepository()
    var todayArray: Results<Todo>?
    var soonArray: Results<SpareTodo>?
    var todoType: TodoType = .soon
    var soonEditing = false
    var todayEditing = false
    
    var selectedDate = Date() {
        didSet {
            headerLabel.text = DateFormatter.getYearMonth(date: selectedDate)
            dateLabel.text = DateFormatter.getMonthDayWeekDay(date: selectedDate)
            fetchTodoData()
            todoCollectionView.reloadData()
        }
    }
    
    
    //    private let scrollView = {
    //        let view = UIcrollView()
    //        view.backgroundColor = .green
    //        return view
    //    }()
    private let headerLabel = {
        let view  = UILabel()
        view.textColor = QColor.accentColor
        view.font = DINPro.size20.bold()
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
        label.font = Pretendard.size20.regular()
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
    private lazy var registerButton = {
        let view = UIButton()
        view.setTitleColor(QColor.grayColor, for: .normal)
        view.setTitle("추가", for: .normal)
        view.titleLabel?.font = Pretendard.size18.bold()
        view.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.isEnabled = false
        return view
    }()
    private let textField = {
        let view = UITextField()
        view.borderStyle = .none
        view.returnKeyType = .done
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setCalendarView()
        
        setDelegate()
        setTextFieldIsHidden(isHidden: true)
        //        dismissKeyboardWhenTappedAround()
        addTarget()
        fetchTodoData()
        print(todoRepository.findFileURL())
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        todoCollectionView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func dismissKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func addTarget() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    @objc func textFieldDidChange(){
        if(textField.text!.count == 0){
            registerButton.setTitleColor(QColor.grayColor, for: .normal)
            registerButton.isEnabled = false
        }else {
            registerButton.setTitleColor(QColor.accentColor, for: .normal)
            registerButton.isEnabled = true
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func registerButtonTapped(){
        print("추가함!!")
        addTodo()
        todoCollectionView.reloadData()
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        view.backgroundColor = QColor.backgroundColor
        //        let month = 1
        //        let day = 16
        //        dateLabel.text = "date_text".localized(num1: month, num2: day)
    }
    
    
    override func setConstraints() {
        //        view.addSubview(scrollView)
        //        scrollView.addSubviews([headerLabel,calendarView,dateLabel,todoCollectionView,textFieldBackgroundView])
        //        textFieldBackgroundView.addSubviews([textFieldBorderview,registerButton])
        view.addSubviews([headerLabel,calendarView,dateLabel,todoCollectionView,textFieldBackgroundView])
        textFieldBackgroundView.addSubviews([textFieldBorderview,registerButton])
        textFieldBorderview.addSubview(textField)
        //        scrollView.snp.makeConstraints { make in
        //            make.horizontalEdges.verticalEdges.equalToSuperview()
        //        }
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view).multipliedBy(0.2)
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
        textField.delegate = self
    }
    func addTodo(){
        if let text = textField.text{
            let text = textField.text ?? ""
            
            let date = DateFormatter.convertToFullDateDBForm(date: selectedDate)
            switch todoType{
            case .soon:
                //            soonArray.append(textField.text ?? "")
                spareTodoRepository.createTodo(SpareTodo(contents: text, planDate:date, createdDate: date, position: 0, leafNum: 0))
            case .today:
                todoRepository.createTodo(Todo(contents: text, planDate: date, createdDate: date, position: 0, leafNum: 0))
                //            todayArray.append(textField.text ?? "")
            }
            textField.text = ""
            todoCollectionView.reloadData()
        }
        
    }
    func fetchTodoData(){
        let date = selectedDate
        todayArray = todoRepository.fetchSelectedDateTodo(date: date)
        soonArray = spareTodoRepository.fetchSelectedDateSpareTodo(date: date)
        print(todayArray)
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
        selectedDate = date
    }

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
            let currentPage = calendar.currentPage
            let currentYear = Calendar.current.component(.year, from: currentPage)
            let currentMonth = Calendar.current.component(.month, from: currentPage)
            
            headerLabel.text = "\(currentYear)년 \(currentMonth)월"
        }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            if monthPosition != .current {
                calendar.setCurrentPage(date, animated: true)
                return false
            } else {
                return true
            }
        }

}

extension TodoViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as? TodoCollectionViewCell else {
            return UICollectionViewCell()}
        
        switch indexPath.section{
        case 0:
            let item = soonArray?[indexPath.row] ?? SpareTodo()
            cell.setData(todo: item.contents)
            cell.menuButtonTappedClosure = {
                let menuViewController = MenuViewController()
                menuViewController.modalPresentationStyle = .pageSheet
                menuViewController.todoType = .soon
                menuViewController._id = item._id
                menuViewController.deleteButtonTappedClosure = {
                    self.todoCollectionView.reloadSections(IndexSet(0...0))
                }
                menuViewController.reviseButtonTappedClosure = {
                    cell.setRevising(isRevising: true)
                    cell.openKeyboard()

                }
                self.present(menuViewController, animated: true)
                
            }
            cell.reviseCompleteButtonTappedClosure = { todoText in
                self.spareTodoRepository.updateContents(_id: item._id, contents: todoText)
                self.todoCollectionView.reloadItems(at: [indexPath])
            }
            //                self.soonArray[indexPath.row] = todoText
            //                self.todoCollectionView.reloadData()
            //            }
            //            cell.reviseButtonTappedClosure = {
            ////                self.textField.becomeFirstResponder()
            //                print("reviseButtonTapped")
            //            }
            //            cell.reviseCompleteButtonTappedClosure = { todoText in
            //                self.soonArray[indexPath.row] = todoText
            //                self.todoCollectionView.reloadData()
            //            }
            //            cell.deleteButtonTappedClosure = {
            //                self.soonArray.remove(at: indexPath.row)
            //                print(self.soonArray)
            //                self.todoCollectionView.reloadData()
            //            }
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            cell.setData(todo: item.contents)
            cell.menuButtonTappedClosure = {
                let menuViewController = MenuViewController()
                menuViewController.modalPresentationStyle = .pageSheet
                menuViewController.todoType = .today
                menuViewController._id = item._id
                menuViewController.deleteButtonTappedClosure = {
                    self.todoCollectionView.reloadSections(IndexSet(1...1))
                }
                menuViewController.reviseButtonTappedClosure = {
                    cell.setRevising(isRevising: true)
                    cell.openKeyboard()
                }
                self.present(menuViewController, animated: true)
            }
            cell.reviseCompleteButtonTappedClosure = { todoText in
                self.todoRepository.updateContents(_id: item._id, contents: todoText)
                self.todoCollectionView.reloadItems(at: [indexPath])
            }
            //            cell.reviseButtonTappedClosure = {todoText in
            //                self.todayArray[indexPath.row] = todoText
            //                self.todoCollectionView.reloadData()
            //            }
            //            cell.deleteButtonTapㄱpedClosure = {
            //                self.todayArray.remove(at: indexPath.row)
            //                self.todoCollectionView.reloadData()
            //            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return soonArray?.count ?? 0
        case 1:
            return todayArray?.count ?? 0
        default:
            return 0
        }
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
                self.setTextFieldIsHidden(isHidden: false)
                self.textField.becomeFirstResponder()
                self.todoType = .soon
                self.soonEditing = true
                self.todayEditing = false
                self.todoCollectionView.reloadData()
                
            }
            header.setFocused(isEditing: soonEditing)
        case 1:
            header.setTitle(text: "오늘 할 일")
            header.addButtonComletionHandler = {
                self.setTextFieldIsHidden(isHidden: false)
                self.textField.becomeFirstResponder()
                self.todoType = .today
                self.soonEditing = false
                self.todayEditing = true
                self.todoCollectionView.reloadData()
                
            }
            header.setFocused(isEditing: todayEditing)
        default:
            break
        }
        
        
        return header
    }
    
    func setTextFieldIsHidden(isHidden: Bool) {
        textField.isHidden = isHidden
        textFieldBorderview.isHidden = isHidden
        textFieldBackgroundView.isHidden = isHidden
    }
    
}
extension TodoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width-40, height: 40)
    }
}

extension TodoViewController: UITextFieldDelegate {
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        switch todoType {
    //        case .soon:
    //
    //        case .today:
    //            soonEditing = false
    //            todayEditing = true
    //            todoCollectionView.reloadData()
    //
    //        }
    //    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldIsHidden(isHidden: true)
        soonEditing = false
        todayEditing = false
        todoCollectionView.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        setTextFieldIsHidden(isHidden: true)
        
        if(textField.text?.count ?? 0 > 0){
            addTodo()
            todoCollectionView.reloadData()
            return true
        } else {
            return false
        }
        
    }
}

