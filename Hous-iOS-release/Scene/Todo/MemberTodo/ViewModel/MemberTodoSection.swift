//
//  MemberTodoSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import RxDataSources

struct MemberTodoSection {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case members(num: Int)
    case todos(num: Int)
  }

  enum Item: Equatable {
    case members(member: MemberDTO)
    case todos(todo: TodoByMemberDTO)

    static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.members(_), .members(_)),
                 (.todos(_), .todos(_)):
                return true
            default:
                return false
            }
        }
  }
}
