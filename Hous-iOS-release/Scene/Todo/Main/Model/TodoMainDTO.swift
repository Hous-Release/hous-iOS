//
//  TodoMainDTO.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/13.
//

import Foundation

// MARK: - TodoMain
struct TodoMainDTO: Codable {
  let date, dayOfWeek: String
  let myTodos: [MyTodoDTO]
  let myTodosCnt: Int
  let ourTodos: [OurTodoDTO]
  let ourTodosCnt, progress: Int
}

// MARK: - MyTodo
struct MyTodoDTO: Codable {
  let isChecked: Bool
  let todoId: Int
  let todoName: String
}

// MARK: - OurTodo
struct OurTodoDTO: Codable {
  let nicknames: [String]
  let status, todoName: String
}
