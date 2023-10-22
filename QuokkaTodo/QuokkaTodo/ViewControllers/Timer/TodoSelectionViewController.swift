//
//  TodoSelectionViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/10/23.
//

import UIKit
import RealmSwift

class TodoSelectionViewController: BaseViewController {
    let todoRepository = TodoRepository()
    let spareTodoRepository = SpareTodoRepository()
    var todayArray: Results<Todo>?
    var soonArray: Results<SpareTodo>?
    var todoCellTappedClosure: ((ObjectId,TodoType)->Void)?
 
    private let titleLabel = {
        let view = UILabel()
        view.font = Pretendard.size21.bold()
        view.textColor = QColor.accentColor
        view.text = "진행 할 투두 선택하기"
        return view
    }()
    private let emptyViewLabel = {
        let view = UILabel()
        view.font = Pretendard.size15.semibold()
        view.textColor = QColor.fontColor
        view.textAlignment = .center
        view.numberOfLines = 2
        view.text = "오늘 진행 할 투두가 없습니다.\n투두 탭에서 투두를 추가해주세요."
        return view
    }()
    private lazy var todoCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = CGFloat(16)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width-40, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.bounces = true
        view.backgroundColor = .none
        view.register(TodoPlayCollectionViewCell.self, forCellWithReuseIdentifier: TodoPlayCollectionViewCell.identifier)
        view.register(TodoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodoHeaderView.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.preferredCornerRadius = 20
        }
        setDelegate()
        fetchTodayUncompletedTodoData()
        fetchSpareUncompletedTodoData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoCollectionView.reloadData()
        toggleEmptyView()
    }
    override func setConstraints() {
        view.addSubviews([titleLabel,emptyViewLabel,todoCollectionView])
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        todoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(40)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-10)
        }
        emptyViewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(10)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    private func toggleEmptyView() {
        if(todayArray?.count == 0 && soonArray?.count == 0){
            todoCollectionView.isHidden = true
            
        }else {
            todoCollectionView.isHidden = false
        }
    }
    
    func setDelegate(){
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
    }
    func fetchTodayUncompletedTodoData(){
        let today = Date()
        todayArray = todoRepository.fetchSelectedDateUnCompletedTodo(date: today)
    }
    func fetchSpareUncompletedTodoData() {
        soonArray = spareTodoRepository.fetchUnCompletedTodo()
    }

}

extension TodoSelectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: TodoPlayCollectionViewCell.identifier, for: indexPath) as? TodoPlayCollectionViewCell else {
            return UICollectionViewCell()}
        
        switch indexPath.section{
        case 0:
            let item = soonArray?[indexPath.row] ?? SpareTodo()
            cell.setData(todo: item.contents)
           
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            cell.setData(todo: item.contents)
        default:
            break
        }
        cell.setLayout()
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
        switch indexPath.section{
        case 0:
            let item = soonArray?[indexPath.row] ?? SpareTodo()
            todoCellTappedClosure?(item._id,.soon)
            dismiss(animated: true)
            
        case 1:
            let item = todayArray?[indexPath.row] ?? Todo()
            todoCellTappedClosure?(item._id,.today)
            dismiss(animated: true)
        default:
            break
        }
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
            header.setFocused(isEditing: true)
            header.hideAddButton()
    
        case 1:
            header.setTitle(text: "오늘 할 일")
            header.setFocused(isEditing: true)
            header.hideAddButton()
        
        default:
            break
        }
        
        return header
    }
    
    
    
}
extension TodoSelectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
}

