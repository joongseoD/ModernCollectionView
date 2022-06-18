//
//  NestedGroupCollectionViewController.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/18.
//

import UIKit

final class NestedGroupCollectionViewController: UIViewController {
    let headerRegistration: UICollectionView.SupplementaryRegistration<TitleHeaderReusableView> = {
        return .init(elementKind: "title") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(string) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.nestedLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        CellTypes.allCases.forEach { collectionView.register($0.cellType, forCellWithReuseIdentifier: $0.reuseIdentifier) }
        return collectionView
    }()
    
    lazy var datasource: UICollectionViewDiffableDataSource<SectionLayout, CellTypes> = {
        let datasource = UICollectionViewDiffableDataSource<SectionLayout, CellTypes>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: itemIdentifier.reuseIdentifier,
                for: indexPath
            ) as! CellType
            cell.setViewModel(itemIdentifier.viewModel)
            return cell
        }
        
        datasource.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else { fatalError() }
            let section = datasource.snapshot().sectionIdentifiers[indexPath.section]
            print("#### ", elementKind)
            
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: self.headerRegistration,
                for: indexPath
            )
        }
        
        return datasource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        updateData()
    }
    
    private func setup() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayout, CellTypes>()
        let sections = SectionLayout.allCases
        snapshot.appendSections(sections)
        sections.forEach { section in
            let items = section.viewModel.cellViewModels.map { $0.type }
            snapshot.appendItems(items, toSection: section)
        }
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension UICollectionViewLayout {
    static var basicLayout: UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static var nestedLayout: UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let layout = SectionLayout(index: sectionIndex) else { return nil }
            return SectionLayoutProvider(section: layout).layout
        }
    }
}
