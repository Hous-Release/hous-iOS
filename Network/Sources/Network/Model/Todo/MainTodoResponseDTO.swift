//
//  MainTodoResponseDTO.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

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

  // MARK: - GetTodoDetailInfo
  struct TodoSummaryResponseDTO: Decodable {
    public let dayOfWeeks: String
    public let name: String
    public let selectedUsers: [SelectedUser]
  }

  
}
