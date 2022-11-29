//
//  TodoByMemberDTO.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import UIKit

public struct MemberDTO {
  let userName: String
  let color: String
}

public struct MemberTodoModel: Hashable {
  public let userName: String
  public let color: UIColor
  public let totalTodoCnt: Int
  public let dayOfWeekTodos: [DayOfWeekTodoModel]
}

public struct DayOfWeekTodoModel: Hashable {
  public let dayOfWeek: String
  public let dayOfWeekTodos: [TodoInfoWithIdModel]
}

public struct TodoInfoWithIdModel {

  public let uuid = UUID()
  public let todoId: Int
  public let todoName: String
}

extension TodoInfoWithIdModel: Hashable {
  public static func ==(lhs: TodoInfoWithIdModel, rhs: TodoInfoWithIdModel) -> Bool {
    return lhs.uuid == rhs.uuid
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(uuid)
  }
}
