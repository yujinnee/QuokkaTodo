//
//  DiaryViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/20/23.
//

import UIKit
import RealmSwift

class DiaryViewController: BaseViewController {
    let diaryRepository = DiaryRepository()
    var diaryArray: Results<Diary>?

    private let diaryTableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 500
        view.isUserInteractionEnabled = true
        return view
    }()
    private let diaryLockedImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "img_locked_diary")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureView() {
        navigationItem.title = "한 해의 행복 일기🤎"
        view.backgroundColor = QColor.backgroundColor
        diaryTableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self

        diaryLockedImageView.isHidden = false
        setInitialView()
    }
    override func setConstraints() {
        view.addSubviews([diaryTableView,diaryLockedImageView])
        
        diaryTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        diaryLockedImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setInitialView() {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let thisYearString = format.string(from: Date())
        let thisYearNum = Int(thisYearString) ?? 2010
      
        if(DateFormatter.islastDayOfThisYesr()){
            diaryLockedImageView.isHidden = true
            diaryArray = diaryRepository.fetchAnnuallyDiary(year: thisYearNum)
        }else {
            diaryLockedImageView.isHidden = false
            if(diaryRepository.hasPreviousDiary()){
                diaryLockedImageView.isHidden = true
               
                let lastYearNum = thisYearNum - 1
                diaryArray = diaryRepository.fetchAnnuallyDiary(year: lastYearNum)
            }else{
                diaryLockedImageView.isHidden = false
            }
        }

    }
    

}

extension DiaryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {return UITableViewCell()}
        let isFirst = indexPath.row == 0 ? true : false
        let isLast = indexPath.row == diaryArray!.count - 1  ? true : false
        cell.setData(item: diaryArray?[indexPath.row] ?? Diary(),isFirst: isFirst,isLast: isLast)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray?.count ?? 0
    }
}
