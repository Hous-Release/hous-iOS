//
//  ByDayTodoSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import Foundation
import RxDataSources
import Network

public struct MyOurTodoSection {
  public typealias Model = SectionModel<Section, Item>

  public enum Section: Equatable {
    case guide
    case countTodo
    case myTodo(num: Int)
    case myTodoEmpty
    case ourTodo(num: Int)
    case ourTodoEmpty
  }

  public enum Item: Equatable {
    case guide
    case countTodo(num: Int)
    case myTodo(todos: ByDayTodoDTO.Response.MyTodoByDayDTO)
    case myTodoEmpty
    case ourTodo(todos: ByDayTodoDTO.Response.OurTodoByDayDTO)
    case ourTodoEmpty

    public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.myTodo, .myTodo),
                 (.ourTodo, .ourTodo):
                return true
            default:
                return false
            }
        }
  }
}
