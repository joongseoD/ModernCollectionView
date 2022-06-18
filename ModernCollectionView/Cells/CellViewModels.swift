//
//  CellViewModels.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/18.
//

import Foundation

protocol CellViewModel {
    var id: UUID { get }
    
    var string: String? { get }
    
    var type: CellTypes { get }
}
struct PanelCellViewModel: CellViewModel, Hashable {
    var string: String?
    
    var id = UUID()
    
    var type: CellTypes { .panel1(self) }
}
struct Panel2CellViewModel: CellViewModel, Hashable {
    var string: String?
    
    var id = UUID()
    
    var type: CellTypes { .panel2(self) }
}
struct AlbumCellViewModel: CellViewModel, Hashable {
    var string: String?
    
    var id = UUID()
    
    var type: CellTypes { .album1(self) }
}
struct CurationCellViewModel: CellViewModel, Hashable {
    var string: String?
    
    var id = UUID()
    
    var type: CellTypes { .curation(self) }
}
