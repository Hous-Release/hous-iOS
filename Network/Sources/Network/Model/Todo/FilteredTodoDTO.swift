//
//  FilteredTodoDTO.swift
//  
//
//  Created by 김지현 on 2023/06/02.
//

import Foundation

public enum FilteredTodoDTO {
  public enum Request { }
  public enum Response { }
}

public extension FilteredTodoDTO.Request {
  struct getTodosFilteredRequestDTO: Encodable {

    public let dayOfWeeks: [String]
    public let onboardingIds: [Int]

    public init(dayOfWeeks: [String], onboardingIds: [Int]) {
      self.dayOfWeeks = dayOfWeeks
      self.onboardingIds = onboardingIds
    }
  }
}

public extension FilteredTodoDTO.Response {

  // MARK: - FilteredTodoResponseDTO
  struct FilteredTodoResponseDTO: Decodable {
    public let todos: [TodoDTO]
    public let todoCnt: Int
  }

  struct TodoDTO: Decodable {
    public let isNew: Bool
    public let todoId: Int
    public let todoName: String
  }

  // MARK: - GetOnlyMyTodo
    struct OnlyMyTodosDTO: Decodable {
        public let myTodos: [MyTodoDTO]
        public let myTodosCnt: Int
    }

    struct MyTodoDTO: Decodable {
        public let dayOfWeeks: String
        public let todoName: String
    }
}
