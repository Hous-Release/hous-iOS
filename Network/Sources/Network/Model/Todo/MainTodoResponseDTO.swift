//
//  MainTodoResponseDTO.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

public extension MainTodoResponseDTO.Response {

    // MARK: - TodoMain
    struct TodoMainDTO: Decodable {
      let date, dayOfWeek: String
      let myTodos: [MyTodoDTO]
      let myTodosCnt: Int
      let ourTodos: [OurTodoDTO]
      let ourTodosCnt, progress: Int
    }

    // MARK: - MyTodo
    struct MyTodoDTO: Decodable {
      let isChecked: Bool
      let todoId: Int
      let todoName: String
    }

    // MARK: - OurTodo
    struct OurTodoDTO: Decodable {
      let nicknames: [String]
      let status, todoName: String
    }
}
