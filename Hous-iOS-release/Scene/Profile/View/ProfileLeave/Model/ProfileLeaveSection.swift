//
//  ProfileLeaveSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/13.
//

import Foundation
import RxDataSources
import Network

public struct OnlyMyTodoSection {
  public typealias Model = SectionModel<Section, Item>

  public enum Section: Equatable {
    case guide
    case countTodo
    case myTodo(num: Int)
    case myTodoEmpty
  }

  public enum Item: Equatable {
    case guide
    case countTodo(num: Int)
    case myTodo(todos: FilteredTodoDTO.Response.MyTodoDTO)
    case myTodoEmpty

    public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.myTodo, .myTodo):
                return true
            default:
                return false
            }
        }
  }
}
