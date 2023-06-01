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
    // MARK: 요일별
    case getDaysOfWeekTodos
    case getOnlyMyTodo
    // MARK: 멤버별
    case getMemberTodos
    // MARK: 추가 / 수정
    case getAssignees
    case getModifyTodoID(Int)
    case updateTodo(
      _ id: Int?,
      _ dto: UpdateTodoDTO.ModifyTodo
    )
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
    // MARK: 요일별
    case .getDaysOfWeekTodos:
      return "todos/day"
    case .getOnlyMyTodo:
        return "todos/me"
    // MARK: 멤버별
    case .getMemberTodos:
      return "todos/member"
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
    // MARK: 요일별
    case .getDaysOfWeekTodos:
      return .get
    case .getOnlyMyTodo:
      return .get
    // MARK: 멤버별
    case .getMemberTodos:
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
    // MARK: 요일별
    case .getDaysOfWeekTodos:
      return .requestPlain
    case .getOnlyMyTodo:
      return .requestPlain
    // MARK: 멤버별
    case .getMemberTodos:
      return .requestPlain
    // MARK: 추가 / 수정
    case .getAssignees:
      return .requestPlain
    case .getModifyTodoID:
      return .requestPlain
    case .updateTodo(_ ,let dto):
      return .body(dto)
    }
  }
}
