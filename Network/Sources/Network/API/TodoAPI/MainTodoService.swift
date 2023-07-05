//
//  File.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation
import Alamofire

public enum TodoService {
  // MARK: main
  case getTodos
  case checkTodo(
    _ todoId: Int,
    _ status: MainTodoDTO.Request.updateTodoRequestDTO
  )
  case getTodoSummary(_ todoId: Int)
  case deleteTodo(_ todoId: Int)
  case getOnlyMyTodo
  // MARK: 추가 / 수정
  case getAssignees
  case getModifyTodoID(Int)
  case updateTodo(
    _ id: Int?,
    _ dto: UpdateTodoDTO.ModifyTodo
  )

  // 추후 삭제
  // MARK: 요일별
  case getDaysOfWeekTodos
  // MARK: 멤버별
  case getMemberTodos
}

extension TodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
      // MARK: main
    case .getTodos:
      return "/todos/main"
    case let .checkTodo(todoId, _):
      return "/todo/\(todoId)/check"
    case let .getTodoSummary(todoId):
      return "/todo/\(todoId)/summary"
    case let .deleteTodo(todoId):
      return "/todo/\(todoId)"
    case .getOnlyMyTodo:
      return "todos/me"
      // MARK: 추가 / 수정
    case .getAssignees:
      return "/todo"
    case .getModifyTodoID(let id):
      return "todo/\(id)"
    case .updateTodo(let id, _):
      guard let id = id else {
        return "/todo"
      }
      return "/todo/\(id)"

      // MARK: 요일별
    case .getDaysOfWeekTodos:
      return "todos/day"
      // MARK: 멤버별
    case .getMemberTodos:
      return "todos/member"
    }
  }

  public var method: HTTPMethod {
    switch self {
      // MARK: main
    case .getTodos:
      return .get
    case .checkTodo:
      return .post
    case .getTodoSummary:
      return .get
    case .deleteTodo:
      return .delete
    case .getOnlyMyTodo:
      return .get
      // MARK: 추가 / 수정
    case .getAssignees:
      return .get
    case .getModifyTodoID:
      return .get
    case .updateTodo(let id, _):
      guard id != nil else {
        return .post
      }
      return .put

      // MARK: 요일별 멤버별
    case .getDaysOfWeekTodos, .getMemberTodos:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
      // MARK: main
    case .getTodos:
      return .requestPlain
    case let .checkTodo(_, status):
      return .body(status)
    case .getTodoSummary:
      return .requestPlain
    case .deleteTodo:
      return .requestPlain
    case .getOnlyMyTodo:
      return .requestPlain
      // MARK: 추가 / 수정
    case .getAssignees:
      return .requestPlain
    case .getModifyTodoID:
      return .requestPlain
    case .updateTodo(_ ,let dto):
      return .body(dto)

      // MARK: 요일별 멤버별
    case .getDaysOfWeekTodos, .getMemberTodos:
      return .requestPlain
    }
  }
}
