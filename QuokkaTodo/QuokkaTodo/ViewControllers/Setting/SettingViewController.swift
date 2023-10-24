//
//  SettingViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/14/23.
//

import UIKit

class SettingViewController: BaseViewController {
    let contentsArray = ["개인정보 처리방침","오픈소스","문의 하기","앱 버전"]
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func configureView() {
        view.backgroundColor = QColor.backgroundColor
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        
        navigationItem.title = "설정"
        
    }
    override func setConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.setTitle(title: contentsArray[indexPath.row])
        if(indexPath.row == 3){
            cell.setVersionLabel()
        }else{
            cell.setChevronButton()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController()
        switch indexPath.row{
        case 0:
            vc.urlString = "https://succulent-stallion-ac8.notion.site/f1857cffd9074570ba274e10fc91a1b9?pvs=4"
           
        case 1:
            vc.urlString = "https://succulent-stallion-ac8.notion.site/29014c9b23be42eb8386eb5c2dbe72dd?pvs=4"
        case 2:
            vc.urlString = "https://www.instagram.com/quokkatodo/"
        default: return
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
