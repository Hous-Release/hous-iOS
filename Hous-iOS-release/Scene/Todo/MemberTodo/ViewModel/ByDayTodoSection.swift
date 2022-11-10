//
//  ByDayTodoSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import Foundation
import RxDataSources
import Network
// todo: 
public struct ByDayTodoSection {
  public typealias Model = SectionModel<Section, Item>

  public enum Section: Equatable {
    case countTodo
    case myTodo(num: Int)
    case ourTodo(num: Int)
  }

  public enum Item: Equatable {
    case countTodo(num: Int)
    case myTodo(todos: ByDayTodoDTO.Response.MyTodoByDayDTO)
    case ourTodo(todos: ByDayTodoDTO.Response.OurTodoBtDayDTO)

    public static func == (lhs: Self, rhs: Self) -> Bool {
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
