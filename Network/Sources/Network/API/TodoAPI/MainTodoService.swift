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
}

extension MainTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getTodos:
      return "/todos"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getTodos:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case .getTodos:
      return .requestPlain
    }
  }
}
