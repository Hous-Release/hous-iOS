//
//  File.swift
//  
//
//  Created by 김지현 on 2022/10/24.
//

import Foundation

public extension MemberTodoDTO.Response {

    // MARK: - [] + totalCount
    struct MemberTodosResponseDTO: Decodable {
        public let todos: [MemberTodoDTO]
        public let totalRoomTodoCnt: Int
    }

    // MARK: - Members + Todos
    struct MemberTodoDTO: Decodable {
        public let userName, color: String
        public let totalTodoCnt: Int
        public let dayOfWeekTodos: [DayOfWeekTodo]
    }

    // MARK: - Todos
    struct DayOfWeekTodo: Decodable, Hashable {
        public let dayOfWeek: String
        public let dayOfWeekTodos: [TodoInfo]
    }

    // MARK: - Todo
    struct TodoInfo: Decodable, Hashable {
        public let todoId: Int
        public let todoName: String
    }
}
