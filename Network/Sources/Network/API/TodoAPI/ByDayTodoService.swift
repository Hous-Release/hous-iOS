//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/01.
//

import Foundation
import Alamofire

public enum ByDayTodoService {
  case getDaysOfWeekTodos
  case getOnlyMyTodo
}

extension ByDayTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getDaysOfWeekTodos:
      return "todos/day"
    case .getOnlyMyTodo:
        return "todos/me"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getDaysOfWeekTodos:
      return .get
    case .getOnlyMyTodo:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case .getDaysOfWeekTodos:
      return .requestPlain
    case .getOnlyMyTodo:
      return .requestPlain
    }
  }
}
