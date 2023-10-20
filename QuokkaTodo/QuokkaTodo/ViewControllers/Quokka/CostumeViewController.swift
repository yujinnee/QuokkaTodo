//
//  CostumeViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import UIKit

class CostumeViewController: BaseViewController {
    let levelRepository = LevelRepository()
    
    var costumeArray = Array<CostumeModel>()
    var selectedIndex = 0

//    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, CostumeModel>! = nil

    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쿼카 꾸미기"
        configureHierarchy()
        configureDataSource()
        collectionView.delegate = self
    }
}

extension CostumeViewController {
    func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.333))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension CostumeViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.clipsToBounds = true
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CostumeCollectionViewCell, CostumeModel> { (cell, indexPath, model) in
            // Populate the cell with our item description.
            
//            cell.contentView.backgroundColor = QColor.backgroundColor
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 10

            switch indexPath.row == UserDefaultsHelper.standard.selectedCostume{
            case true:
                cell.contentView.layer.borderColor = QColor.accentColor.cgColor
                cell.contentView.layer.borderWidth = 2
            case false:
                cell.contentView.layer.borderColor = QColor.grayColor.cgColor
                cell.contentView.layer.borderWidth = 1
            }
            switch model.isLocked{
            case true: 
                cell.contentView.backgroundColor = QColor.grayColor
                cell.costumeImageView.image = UIImage(named:"icon_lock")
            case false:
                cell.contentView.backgroundColor = QColor.backgroundColor
                cell.costumeImageView.image = UIImage(named: model.imageTitle)
            }
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, CostumeModel>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: CostumeModel) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, CostumeModel>()
        snapshot.appendSections([.main])
        
        for i in 0..<Costume.allCases.count{
           
            let costumeImageName = Costume.allCases[i].imageName
            var isLocked = true
            if(i<=calculateLevel()+1){
                isLocked = false
            }
            
            costumeArray.append(CostumeModel(isLocked: isLocked, imageTitle: costumeImageName))
        }
        snapshot.appendItems(costumeArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func calculateLevel()->Int{
        let feedLeafNum = levelRepository.readLeafNum()
        let feedNutritionNum = levelRepository.readNutritionNum()
        let sum = Double(feedLeafNum)*3.323 + Double(feedNutritionNum)*6.216
        let level = Int(sum/100)
        return level
    }
}

extension CostumeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item = costumeArray[indexPath.row]

     
        
        switch item.isLocked {
        case true:
            print("잠겨있는 아이템 입니다.")
        case false:
            print("잠겨 있지 않은 아이템입니다.")
            selectedIndex = indexPath.row
            UserDefaultsHelper.standard.selectedCostume = indexPath.row
            collectionView.reloadData()
        }
        
        print("dd")
        
    }
}
