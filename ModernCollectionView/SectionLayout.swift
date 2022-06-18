//
//  SectionLayout.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/18.
//

import Foundation

enum SectionLayout: Hashable, CaseIterable {
    case panel(PanelSectionViewModel)
    case albums(AlbumSectionViewModel)
    case curation(CurationSectionViewModel)
    
    var header: SectionHeader? { viewModel.header }
    
    static var allCases: [SectionLayout] {
        return [
            .panel(.init()),
            .albums(.init()),
            .curation(.init())
        ]
    }
    
    init?(index: Int) {
        guard SectionLayout.allCases.indices.contains(index) else { return nil }
        self = SectionLayout.allCases[index]
    }
    
    var viewModel: SectionViewModelType {
        switch self {
        case .panel(let sectionViewModel):
            return sectionViewModel
        case .albums(let sectionViewModel):
            return sectionViewModel
        case .curation(let sectionViewModel):
            return sectionViewModel
        }
    }
    
    static func == (lhs: SectionLayout, rhs: SectionLayout) -> Bool {
        lhs.viewModel.id == rhs.viewModel.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.viewModel.id)
    }
}

protocol SectionViewModelType {
    var id: UUID { get }
    
    var header: SectionHeader? { get }
    
    var cellViewModels: [CellViewModel] { get }
}

struct PanelSectionViewModel: SectionViewModelType {
    var id = UUID()
    
    var header: SectionHeader? { nil }
    
    var cellViewModels: [CellViewModel] = [
        PanelCellViewModel(),
        Panel2CellViewModel(),
        PanelCellViewModel(),
        PanelCellViewModel()
    ]
}

struct AlbumSectionViewModel: SectionViewModelType {
    var id = UUID()
    
    var header: SectionHeader? { .title("안녕!") }
    
    var cellViewModels: [CellViewModel] = [
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel(),
        AlbumCellViewModel()
    ]
}

struct CurationSectionViewModel: SectionViewModelType {
    var id = UUID()
    var header: SectionHeader? { .title("안녕!") }
//    var header: SectionHeader? {
//        .shortcut(
//            .init(
//                title: "shortcut",
//                shortcutTitle: "button",
//                shortcutURL: ""
//            )
//        )
//    }
    
    var cellViewModels: [CellViewModel] = [
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel(),
        CurationCellViewModel()
    ]
}
