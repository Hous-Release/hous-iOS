//
//  MemberTodoSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import RxDataSources
import Network

public struct MemberSection {
  public typealias Model = SectionModel<Section, Item>

  public enum Section: Equatable {
    //case members(num: Int)
    case members(num: Int)
  }

  public enum Item: Equatable {
    //case members(member: MemberDTO)
    case members(member: MemberDTO)

    public static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.members(_), .members(_)):
        return true
      }
    }
  }
}

public enum TodoByMemSection: Hashable {
  case totalNum
  case main
}

public enum TodoByMemListItem: Hashable {
  case totalNum(Int)
  case header(MemberHeaderItem)
  case todo(MemebrTodoItem)
}
