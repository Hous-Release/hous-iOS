//
//  MainTodoResponseDTO.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

public extension MainTodoDTO.Response {

    // MARK: - TodoMain
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
}
