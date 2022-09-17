//
//  TodoMainSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/15.
//

import Foundation
import RxDataSources

struct TodoMainSection {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case myTodo(num: Int)
    case ourTodo(num: Int)
  }
  enum Item: Equatable {
    case myTodo(todos: MyTodoDTO)
    case ourTodo(todos: OurTodoDTO)

    static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.myTodo(_), .myTodo(_)),
                 (.ourTodo(_), .ourTodo(_)):
                return true
            default:
                return false
            }
        }
  }
}
