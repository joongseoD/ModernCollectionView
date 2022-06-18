//
//  ViewController.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/16.
//

import UIKit
import Combine

class ViewController: UIViewController {

    // iOS 13
    // diffable datasource
    // protocol이 아닌 generic class이다.
    // diffable datasource class가 UICollectionViewDataSource를 conform하고 있다.
    // 기존 방식은 data가 업데이트되면 reloadData()를 호출해서
    // but reloadData는 애니메이션되지 않은 효과가 나타나 사용자 경험이 저하된다고 함
    // 궁극적으로 UI(CollectionView)가 가진 data와 실제 data에 차이가 있는 경우 error가 발생할 잠재성이 있음
    // 'centrailize된 truth가 없기 떄문'
    // Diffable에는 apply()라는 메서드로 데이터를 반영한다.
    // snapshot
    // snapshot은 현재 UI state의 truth이다.
    // section과 item은 더 이상 indexPath가 아니라 유니크한 identifier로 업데이트 된다.
    // 따라서 section과 item은 hashable을 준수해야 한다.
    
    // iOS 14
    
    
    let collectionView: UICollectionView = {
        // TODO: Compositional Layout으로 교체
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private let headerCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Section> = {
        return .init { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.rawValue
            cell.contentConfiguration = content
            
            let headerOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: headerOption)]
        }
    }()
    
    private let itemCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, String> = {
        return .init { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier
            cell.contentConfiguration = content
        }
    }()
    
    lazy var datasource: UICollectionViewDiffableDataSource<Section, ItemType> = {
        return .init(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell() }
            switch itemIdentifier {
            case .section(let section):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.headerCellRegistration,
                    for: indexPath,
                    item: section
                )
            case .item(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.itemCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
    }()
    
    private let viewModel = ViewModel()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bindViewModel()
    }
    
    private func setup() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(reload: Just(()).eraseToAnyPublisher()))
        
        output.data
            .map { sectionModels in
                var snapshot = NSDiffableDataSourceSnapshot<Section, ItemType>()
                snapshot.appendSections(Section.allCases)
                sectionModels.forEach { sectionModel in
                    snapshot.appendItems([.section(sectionModel.section)], toSection: sectionModel.section)
                    
                    let items = sectionModel.items.map { ItemType.item($0) }
                    snapshot.appendItems(items, toSection: sectionModel.section)
                }
                return snapshot
            }
            .sink { [weak self] in self?.datasource.apply($0, animatingDifferences: true, completion: nil) }
            .store(in: &cancellables)
    }
}

class CollectionViewCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
