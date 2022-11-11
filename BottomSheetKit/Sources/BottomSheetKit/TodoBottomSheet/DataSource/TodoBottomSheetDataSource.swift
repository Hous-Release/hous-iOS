//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import Foundation

public enum TodoBottomSheetDataSource { }

extension TodoBottomSheetDataSource {
  enum Section: Int, Hashable, CaseIterable {
    case homies
  }
  enum Item: Hashable, Equatable {
    case homie(HomieCellModel)
  }
}
