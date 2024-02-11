//
//  TodoViewController.swift
//  QoukkaTodo
//
//  Created by 이유진 on 2023/09/27.
//

import UIKit
import FSCalendar
import RealmSwift


class TodoViewController: BaseViewController{
    let todoRepository = TodoRepository()
    var todayArray: Results<Todo>?
    var soonArray: Results<Todo>?
    var todoType: TodoType = .spareTodo
    var soonEditing = false
    var todayEditing = false
    let maxLength = 200
    
    var selectedDate = Date() {
        didSet {
            headerLabel.text = DateFormatter.getYearMonth(date: selectedDate)
            dateLabel.text = DateFormatter.getMonthDayWeekDay(date: selectedDate)
            fetchTodoData()
            todoCollectionView.reloadSections(IndexSet(1...1))
        }
    }
    
    private let headerLabel = {
        let view  = UILabel()
        view.textColor = QColor.accentColor
        view.font = DINPro.size20.bold()
        let now = Date()
        view.text = DateFormatter.getYearMonth(date: now)
        return view
    }()
    private let todayButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "clock.arrow.circlepath"), for: .normal)
        view.tintColor = QColor.accentColor
        return view
    }()
    
    private let calendarView = {
        let view = FSCalendar()
        view.tintColor = QColor.accentColor
        view.backgroundColor = QColor.backgroundColor
        view.allowsSelection = true
        return view
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.textColor = QColor.accentColor
        label.font = Pretendard.size20.regular()
        let now = Date()
        label.text = DateFormatter.getMonthDayWeekDay(date: now)
        return label
    }()
    
    private lazy var todoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 3
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
        //        view.layer.borderColor = QColor.accentColor.cgColor
        //        view.layer.borderWidth = 1
        //        view.layer.cornerRadius = 10
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
        dismissKeyboardWhenTappedAround()
        addTarget()
        fetchTodoData()
        fetchSpareTodoData()
        print(todoRepository.findFileURL())
        setKeyboardObserver()
        setStatusBarBackgroundColor()
        sendNotification()
        
    }
    private func setStatusBarBackgroundColor() {
        let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar.backgroundColor = .white
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        
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
        todoCollectionView.addGestureRecognizer(tap)
    }
    func addTarget() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        todayButton.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
        //        headerLabel.addTarget(self, action: #selector(todayButtonTapped), for: .touchUpInside)
    }
    @objc func todayButtonTapped() {
        calendarView.setCurrentPage(Date(), animated: true)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func registerButtonTapped(){
        addTodo()
    }
    override func configureView() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "Logo"))
        navigationController?.navigationBar.backgroundColor = QColor.backgroundColor
        view.backgroundColor = QColor.backgroundColor
        //        preferredStatusBarStyle = .darkContent
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func setConstraints() {
        
        view.addSubviews([headerLabel,todayButton,calendarView,dateLabel,todoCollectionView,textFieldBackgroundView])
        textFieldBackgroundView.addSubviews([textFieldBorderview,registerButton])
        textFieldBorderview.addSubview(textField)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(150)
            make.height.equalTo(32)
        }
        todayButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(50)
            make.height.equalTo(32)
        }
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(view).multipliedBy(0.3)
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
            make.trailing.equalTo(registerButton.snp.leading).offset(-2)
        }
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        registerButton.snp.makeConstraints { make in
            
            make.trailing.equalToSuperview().inset(2)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setDelegate(){
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        textField.delegate = self
    }
    func addTodo(){
        if textField.text!.count != 0{
            let text = textField.text ?? ""
            
            
            switch todoType{
            case .spareTodo:
                todoRepository.createTodo(Todo(contents: text, planDate: selectedDate, createdDate: selectedDate, position: 0, todoType: TodoType.spareTodo))
                //
            case .todayTodo:
                todoRepository.createTodo(Todo(contents: text, planDate: selectedDate, createdDate: selectedDate, position: 0, todoType: TodoType.todayTodo))
                calendarView.reloadData()//이벤트 점 표시용 reloadData()
            }
            textField.text = ""
            registerButton.setTitleColor(QColor.grayColor, for: .normal)
            todoCollectionView.reloadData()
        }
    }
    func fetchTodoData(){
        let date = selectedDate
        todayArray = todoRepository.fetchSelectedDateTodayTodo(date: date)
    }
    func fetchSpareTodoData() {
        soonArray = todoRepository.fetchAllSpareTodo()
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
        
        calendarView.appearance.selectionColor = QColor.accentColor
        calendarView.appearance.todayColor = .black
        
        calendarView.appearance.eventDefaultColor = QColor.accentColor
        calendarView.appearance.eventSelectionColor = QColor.accentColor
        
        calendarView.headerHeight = 0
        
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if todoRepository.fetchSelectedDateTodayTodo(date: date).count>0{
            return 1
        }else {
            return 0
        }
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
            let item = soonArray?[indexPath.row] ?? Todo()
            cell.setData(todo: item.contents)
            cell.setLeaf(leafNum: item.leaves.count)
            cell.menuButtonTappedClosure = {
                let menuViewController = MenuViewController()
                menuViewController.modalPresentationStyle = .pageSheet
                menuViewController.todoType = .spareTodo
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
                self.todoRepository.updateContents(_id: item._id, contents: todoText)
                self.todoCollectionView.reloadItems(at: [indexPath])
            }
            cell.setCheckBox(isCompleted: item.isCompleted)
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            cell.setData(todo: item.contents)
            cell.setLeaf(leafNum: item.leaves.count)
            cell.menuButtonTappedClosure = {
                let menuViewController = MenuViewController()
                menuViewController.modalPresentationStyle = .pageSheet
                menuViewController.todoType = .todayTodo
                menuViewController._id = item._id
                menuViewController.deleteButtonTappedClosure = {
                    self.todoCollectionView.reloadSections(IndexSet(1...1))
                    self.calendarView.reloadData()
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
            cell.setCheckBox(isCompleted: item.isCompleted)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = Todo()
        switch indexPath.section{
        case 0:
            item = soonArray?[indexPath.row] ?? Todo()
            
        case 1:
            item = todayArray?[indexPath.row] ?? Todo()
        default:
            break
        }
        var isCompleted = false
        if (item.isCompleted){
            isCompleted = false
        }else {
            isCompleted = true
        }
        todoRepository.updateCompleted(_id: item._id, isCompleted: isCompleted)
        //        todoCollectionView.reloadItems(at: [indexPath])// 체크 설정해제가 애니메이션처럼 되어서 별로임
        todoCollectionView.reloadData()
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
                self.todoType = .spareTodo
                self.soonEditing = true
                self.todayEditing = false
                self.todoCollectionView.reloadData()// header.setFocused 적용하기 위해 호출. 헤더 둘다 커지고 작아지고를 설정해야되서 reloadSection 아니고 reloadData 해야함
                
            }
            header.setFocused(isEditing: soonEditing)
        case 1:
            header.setTitle(text: "이날 할 일")
            header.addButtonComletionHandler = {
                self.setTextFieldIsHidden(isHidden: false)
                self.textField.becomeFirstResponder()
                self.todoType = .todayTodo
                self.soonEditing = false
                self.todayEditing = true
                self.todoCollectionView.reloadData()// header.setFocused 적용하기 위해 호출. 헤더 둘다 커지고 작아지고를 설정해야되서 reloadSection 아니고 reloadData 해야함
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
    private func sendNotification() {
        
        
        let content = UNMutableNotificationContent()
        content.title = "쿼카투두"
        content.body = "오늘의 행복일기를 남기셨나요?🤎"
        
        var component = DateComponents()
        component.minute = 30
        component.hour = 21
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
        let request = UNNotificationRequest(identifier: "timerAlert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ error in
            print(error)
        }
        
    }
    
}
extension TodoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width-40, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let estimatedHeight: CGFloat = 300.0
        let dummyCell = TodoCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: estimatedHeight))
        
        switch indexPath.section{
        case 0:
            let item = soonArray?[indexPath.row] ?? Todo()
            dummyCell.todoLabel.text = item.contents
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            dummyCell.todoLabel.text = item.contents
        default:
            break
        }
        dummyCell.contentView.setNeedsLayout()
        dummyCell.contentView.layoutIfNeeded()
        var height = dummyCell.contentView.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
        dummyCell.prepareForReuse()
        return CGSize(width: width, height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

extension TodoViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(){
        if(textField.text!.count == 0){
            registerButton.setTitleColor(QColor.grayColor, for: .normal)
            registerButton.isEnabled = false
        }else {
            registerButton.setTitleColor(QColor.accentColor, for: .normal)
            registerButton.isEnabled = true
        }
        let textString = textField.text!
        if textString.count >= maxLength {
            let index = textString.index(textString.startIndex, offsetBy: maxLength)
            let fixedText = textString[textString.startIndex..<index]
            textField.text = fixedText + " "
            
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.textField.text = String(fixedText)
            }
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text!.count == 0){
            registerButton.setTitleColor(QColor.grayColor, for: .normal)
            registerButton.isEnabled = false
        }else {
            registerButton.setTitleColor(QColor.accentColor, for: .normal)
            registerButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldIsHidden(isHidden: true)
        soonEditing = false
        todayEditing = false
        todoCollectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.text!.count > 0){
            addTodo()
            todoCollectionView.reloadData()
            return true
        } else {
            return false
        }
    }
}

extension TodoViewController {
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            view.frame.origin.y = 0
            view.frame.origin.y -= keyboardHeight-20
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

