//
//  TodoService.swift
//  
//
//  Created by 김지현 on 2023/06/30.
//

import Foundation
import Alamofire

public enum NewTodoService {

  // 우선 combine 적용하는 todo FilterView 관련 서버통신만 모아둠
  case getTodoByFilter(
    _ dto: MainTodoDTO.Request.getTodosFilteredRequestDTO
  )
  case getTodoDetail(
    _ todoId: Int
  )
}

extension NewTodoService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .getTodoByFilter:
      return "/v1/todos"
    case .getTodoDetail(let todoId):
        return "/v1/todo/\(todoId)/summary"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .getTodoByFilter:
      return .get
    case .getTodoDetail:
        return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case .getTodoByFilter(let dto) :
      return .query(dto)
    case .getTodoDetail:
      return .requestPlain
    }
  }
}
