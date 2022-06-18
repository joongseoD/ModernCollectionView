//
//  ViewModel.swift
//  ModernCollectionView
//
//  Created by Damor on 2022/06/16.
//

import Foundation
import Combine

final class ViewModel {
    
    struct Input {
        let reload: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let data: AnyPublisher<[SectionModel], Never>
    }
    
    func transform(input: Input) -> Output {
        let sectionModel = Just([
            SectionModel(
                section: .header1,
                items: [
                    "1", "2"
                ]
            ),
            SectionModel(
                section: .header2,
                items: [
                    "3", "4"
                ]
            )
        ])
        
        return Output(
            data: sectionModel.eraseToAnyPublisher()
        )
    }
}

// enum은 모든 case가 hashable을 준수하면 자동 synthesise됨
struct SectionModel: Hashable {
    let section: Section
    let items: [String]
}

enum Section: String, CaseIterable {
    case header1
    case header2
}

enum ItemType: Hashable {
    case section(Section)
    case item(String)
}

