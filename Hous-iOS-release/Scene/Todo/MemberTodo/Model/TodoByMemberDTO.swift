//
//  TodoByMemberDTO.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

public struct MemberDTO {
  let userName: String
  let color: String
}

public struct DayOfWeekTodoDTO: Hashable {
    public let dayOfWeek: String
    public let dayOfWeekTodos: [TodoInfoWithIdDTO]
}

public struct TodoInfoWithIdDTO {

    public let uuid = UUID()
    public let todoId: Int
    public let todoName: String
}

extension TodoInfoWithIdDTO : Hashable {
  public static func ==(lhs: TodoInfoWithIdDTO, rhs: TodoInfoWithIdDTO) -> Bool {
        return lhs.uuid == rhs.uuid
    }

  public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
