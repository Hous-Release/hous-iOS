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
    public let isPushNotification: Bool
    public let name: String
    public let selectedUsers: [SelectedUser]?
    public let todoUsers: [TodoUser]
  }
}

public struct SelectedUser: Codable {
  public let color, nickname: String
  public let onboardingID: Int

  enum CodingKeys: String, CodingKey {
    case color, nickname
    case onboardingID = "onboardingId"
  }
}

public struct TodoUser: Codable {
  public init(
    color: String,
    dayOfWeeks: [String],
    isSelected: Bool,
    nickname: String,
    onboardingID: Int
  ) {
    self.color = color
    self.dayOfWeeks = dayOfWeeks
    self.isSelected = isSelected
    self.nickname = nickname
    self.onboardingID = onboardingID
  }

 public let color: String
 public let dayOfWeeks: [String]
 public let isSelected: Bool
 public let nickname: String
 public let onboardingID: Int

  enum CodingKeys: String, CodingKey {
    case color, dayOfWeeks, isSelected, nickname
    case onboardingID = "onboardingId"
  }
}
