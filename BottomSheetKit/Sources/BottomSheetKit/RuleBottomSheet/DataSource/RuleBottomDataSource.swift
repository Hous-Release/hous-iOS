//
//  File.swift
//  
//
//  Created by 김민재 on 2023/05/30.
//

import Foundation

enum RuleBottomDataSource {
    enum Section: Int, CaseIterable {
        case photos
    }

    enum Item: Hashable {
        case photos(_ model: RulePhoto)
    }
}
