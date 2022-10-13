//
//  TodoMainSection.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/15.
//

import Foundation
import RxDataSources
import Network

public struct TodoMainSection {
  public typealias Model = SectionModel<Section, Item>

  public enum Section: Equatable {
    case myTodo(num: Int)
    case ourTodo(num: Int)
  }
  public enum Item: Equatable {
    case myTodo(todos: MainTodoDTO.Response.MyTodoDTO)
    case ourTodo(todos: MainTodoDTO.Response.OurTodoDTO)

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
