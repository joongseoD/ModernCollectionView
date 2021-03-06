//
//  TitleHeaderReusableView.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/18.
//

import UIKit

protocol HeaderReusableViewType: UICollectionReusableView {
//    static func configure(_ header: SectionHeader) -> UICollectionView.SupplementaryRegistration<Self>
}

final class TitleHeaderReusableView: UICollectionReusableView, HeaderReusableViewType {
    static func configure(_ header: SectionHeader) -> UICollectionView.SupplementaryRegistration<TitleHeaderReusableView> {
        return .init(elementKind: header.identifier) { supplementaryView, elementKind, indexPath in
            guard case let .title(title) = header else { return }
            supplementaryView.label.text = "\(title) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
    }
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum SectionHeader {
    case title(String)
    case shortcut(ShortcutHeaderModel)
    
    var identifier: String {
        switch self {
        case .title:
            return "title"
        case .shortcut:
            return "shortcut"
        }
    }
    
    var viewType: HeaderReusableViewType.Type {
        switch self {
        case .title(let string):
            return TitleHeaderReusableView.self
        case .shortcut(let shortcutHeaderModel):
            return TitleHeaderReusableView.self
        }
    }
}

struct ShortcutHeaderModel {
    var title: String
    var shortcutTitle: String
    var shortcutURL: String
}


// ????????? ????????????
// ?????? ???
// ?????? configure
// ?????? element kind
// ????????? viewModel ???????????? ???

