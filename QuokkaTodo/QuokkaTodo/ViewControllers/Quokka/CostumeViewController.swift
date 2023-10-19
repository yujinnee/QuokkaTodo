//
//  CostumeViewController.swift
//  QuokkaTodo
//
//  Created by 이유진 on 10/19/23.
//

import UIKit

class CostumeViewController: BaseViewController {
    let costumeArray = [CostumeModel(isSelected: true, imageTitle: "icon_empty"),
                        CostumeModel(isSelected: false, imageTitle: "icon_birthday_hat"),
                        CostumeModel(isSelected: false, imageTitle: "icon_glasses"),
                        CostumeModel(isSelected: false, imageTitle: "icon_sunglasses")]

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
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CostumeCollectionViewCell, CostumeModel> { (cell, indexPath, model) in
            // Populate the cell with our item description.
            cell.costumeImageView.image = UIImage(named: model.imageTitle)
//            cell.contentView.backgroundColor = QColor.backgroundColor
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 10
            switch model.isSelected{
            case true: 
                cell.contentView.layer.borderColor = QColor.accentColor.cgColor
                cell.contentView.layer.borderWidth = 2
            case false:
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                
                
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
//        let models = (0..<100).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(costumeArray)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
