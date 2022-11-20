//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/20.
//

import Foundation

public enum UpdateTodoDTO {
  public enum Request { }
  public enum Response { }
}

public extension UpdateTodoDTO {

  struct ModifyTodo: Codable {
    let isPushNotification: Bool
    let name: String
    let selectedUsers: [SelectedUser]?
    let todoUsers: [TodoUser]
  }
}

public struct SelectedUser: Codable {
  let color, nickname: String
  let onboardingID: Int

  enum CodingKeys: String, CodingKey {
    case color, nickname
    case onboardingID = "onboardingId"
  }
}

public struct TodoUser: Codable {
  let color: String
  let dayOfWeeks: [String]
  let isSelected: Bool
  let nickname: String
  let onboardingID: Int

  enum CodingKeys: String, CodingKey {
    case color, dayOfWeeks, isSelected, nickname
    case onboardingID = "onboardingId"
  }
}
