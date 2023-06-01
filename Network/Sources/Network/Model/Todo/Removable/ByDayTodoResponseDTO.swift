//
//  ByDayTodoResponseDTO.swift
//  
//
//  Created by 김지현 on 2023/06/02.
//

import Foundation

public extension ByDayTodoDTO.Response {

    // MARK: - [] + totalCount
    struct ByDayTodosResponseDTO: Decodable {
        public let todos: [ByDayTodoDTO]
        public let totalRoomTodoCnt: Int
    }

    // MARK: - Members + Todos
    struct ByDayTodoDTO: Decodable {
        public let dayOfWeek: String
        public let ourTodosCnt: Int
        public let myTodos: [MyTodoByDayDTO]
        public let ourTodos: [OurTodoByDayDTO]
    }

    // MARK: - MyTodo
    struct MyTodoByDayDTO: Decodable {
        public let todoId: Int
        public let todoName: String
    }

    // MARK: - OurTodo
    struct OurTodoByDayDTO: Decodable {
        public let nicknames: [String]
        public let todoId: Int
        public let todoName: String
    }

    struct OnlyMyTodoDTO: Decodable {
        public let myTodos: [OnlyMyTodoDetailDTO]
        public let myTodosCnt: Int
    }

    struct OnlyMyTodoDetailDTO: Decodable {
        public let dayOfWeeks: String
        public let todoName: String
    }
}
