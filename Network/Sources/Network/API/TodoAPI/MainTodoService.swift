//
//  File.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation
import Alamofire

public enum MainTodoService {
  case getTodos
  case checkTodo(
    _ todoId: Int,
    _ status: MainTodoDTO.Request.updateTodoRequestDTO)
  case getMembers
  case updateTodo(
    _ id: Int?,
    _ dto: UpdateTodoDTO.ModifyTodo
    )
}

extension MainTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getTodos:
      return "/todos"
    case let .checkTodo(todoId, _):
      return "/todo/\(todoId)/check"
    case .getMembers:
      return "/todo"
    case .updateTodo(let id, _):
      guard let id = id else {
        return "/todo"
      }
      return "/todo/\(id)"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getTodos:
      return .get
    case .checkTodo:
      return .post
    case .getMembers:
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
    case .getTodos:
      return .requestPlain
    case let .checkTodo(_, status):
      return .body(status)
    case .getMembers:
      return .requestPlain
    case .updateTodo(_ ,let dto):
      return .body(dto)
    }
  }
}
