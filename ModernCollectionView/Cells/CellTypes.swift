//
//  CellTypes.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/18.
//

import UIKit

enum CellTypes: CaseIterable, Hashable {
    case panel1(PanelCellViewModel)
    case panel2(Panel2CellViewModel)
    case album1(AlbumCellViewModel)
    case album2(AlbumCellViewModel)
    case curation(CurationCellViewModel)
    
    var reuseIdentifier: String {
        switch self {
        case .panel1: return "panel1"
        case .panel2: return "panel2"
        case .album1: return "album1"
        case .album2: return "album2"
        case .curation: return "curation"
        }
    }
    
    var cellType: UICollectionViewCell.Type {
        switch self {
        case .panel1:
            return PanelCell.self
        case .panel2:
            return PanelCell.self
        case .album1:
            return AlbumCell.self
        case .album2:
            return AlbumCell.self
        case .curation:
            return CurationCell.self
        }
    }
    
    var viewModel: CellViewModel {
        switch self {
        case .panel1(let viewModel):
            return viewModel
        case .panel2(let viewModel):
            return viewModel
        case .album1(let viewModel):
            return viewModel
        case .album2(let viewModel):
            return viewModel
        case .curation(let viewModel):
            return viewModel
        }
    }
    
    static var allCases: [CellTypes] {
        return [
            .panel1(.init()),
            .panel2(.init()),
            .album1(.init()),
            .album2(.init()),
            .curation(.init())
        ]
    }
}
