//
//  MainTodo.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation

public enum MainTodoDTO {
  public enum Request { }
  public enum Response { }
}

public extension MainTodoDTO.Request {

  struct getTodosFilteredRequestDTO: Encodable {

    public let dayOfWeeks: [String]?
    public let onboardingIds: [Int]?

    public init(dayOfWeeks: [String]?, onboardingIds: [Int]?) {
      self.dayOfWeeks = dayOfWeeks
      self.onboardingIds = onboardingIds
    }
  }

  struct updateTodoRequestDTO: Encodable {

    public let status: Bool

    public init(status: Bool) {
      self.status = status
    }
  }
}

public extension MainTodoDTO.Response {

  // MARK: - TodoMain2
  struct MainTodoResponseDTO: Decodable {
    public let date, dayOfWeek: String
    public let myTodos: [MyTodoDTO]
    public let myTodosCnt: Int
    public let ourTodos: [OurTodoDTO]
    public let ourTodosCnt, progress: Int
  }

  // MARK: - MyTodo
  struct MyTodoDTO: Decodable {
    public let isChecked: Bool
    public let todoId: Int
    public let todoName: String
  }

  // MARK: - OurTodo
  struct OurTodoDTO: Decodable {
    public let nicknames: [String]
    public let status, todoName: String
  }

  struct AssigneeDTO: Decodable {
    public let users: [SelectedUser]
  }

  // MARK: - FilteredTodoResponseDTO
  struct FilteredTodoResponseDTO: Decodable {
    public let todos: [TodoDTO]
    public let todosCnt: Int
  }

  struct TodoDTO: Decodable {
    public let todoId: Int
    public let isNew: Bool
    public let todoName: String
  }

  // MARK: - GetTodoDetailInfo
  struct TodoSummaryResponseDTO: Decodable {
    public let dayOfWeeks: String
    public let name: String
    public let selectedUsers: [SelectedUser]
  }

  // MARK: - MyTodosResign 방 퇴사시 보여주는 나의 투두 요약
  struct MyTodosResignDTO: Decodable {
      public let myTodos: [MyTodoSummaryDTO]
      public let myTodosCnt: Int
  }

  struct MyTodoSummaryDTO: Decodable {
      public let dayOfWeeks: String
      public let todoName: String
  }


}
