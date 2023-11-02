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
//    var diaryArray = ["오늘 아침에 산책하면서 맑은 공기를 맡아 행복했다.🤎","오늘 오랜만에 중학교 친구들 만나서 놀았다!! 방어회🐟를 먹어서 기분이 좋다!","공원에 앉아 있었는데 강아지가 갑자기 나한테 뛰어왔다.그런데 옆에 눈 땡그란 귀여운 아기도 나한테 와서 아가랑 강아지가  같이 있었는데 둘 다 너무 귀여워서 행복했다! ><","오늘 계획 한 일을 다 끝내서 기분이 좋다.😆","공원에 앉아 있었는데 강아지가 갑자기 나한테 뛰어왔다.그런데 옆에 눈 땡그란 귀여운 아기도 나한테 와서 아가랑 강아지가  같이 있었는데 둘 다 너무 귀여워서 행복했다! ><","공원에 앉아 있었는데 강아지가 갑자기 나한테 뛰어왔다.그런데 옆에 눈 땡그란 귀여운 아기도 나한테 와서 아가랑 강아지가  같이 있었는데 둘 다 너무 귀여워서 행복했다! ><","공원에 앉아 있었는데 강아지가 갑자기 나한테 뛰어왔다.그런데 옆에 눈 땡그란 귀여운 아기도 나한테 와서 아가랑 강아지가  같이 있었는데 둘 다 너무 귀여워서 행복했다! ><","좋았다"]
    private let diaryTableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 500
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
        navigationItem.title = "올해의 행복 일기🤎"
        view.backgroundColor = QColor.backgroundColor
        diaryTableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        
        diaryArray = diaryRepository.fetchAll()
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
    

}

extension DiaryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {return UITableViewCell()}
        cell.setData(item: diaryArray?[indexPath.row] ?? Diary())
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryArray?.count ?? 0
    }
}
