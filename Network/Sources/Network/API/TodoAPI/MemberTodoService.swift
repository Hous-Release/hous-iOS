//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/01.
//

import Foundation
import Alamofire

public enum MemberTodoService {
  case getMemberTodos
}

extension MemberTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getMemberTodos:
      return "todos/member"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getMemberTodos:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case .getMemberTodos:
      return .requestPlain
    }
  }
}
