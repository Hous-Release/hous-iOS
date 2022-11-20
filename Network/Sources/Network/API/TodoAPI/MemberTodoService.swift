//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/01.
//

import Foundation
import Alamofire

// TODO: TodoAPI 다 합치기~~~
public enum MemberTodoService {
  case getMemberTodos
  case getModifyTodoID(Int)
}

extension MemberTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getMemberTodos:
      return "todos/member"
    case .getModifyTodoID(let id):
      return "todo/\(id)"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getMemberTodos:
      return .get
    case .getModifyTodoID:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case .getMemberTodos:
      return .requestPlain
    case .getModifyTodoID:
      return .requestPlain
    }
  }
}
