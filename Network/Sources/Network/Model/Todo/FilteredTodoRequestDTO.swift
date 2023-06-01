//
//  FilteredTodoRequestDTO.swift
//  
//
//  Created by 김지현 on 2023/06/02.
//

import Foundation

public extension FilteredTodoDTO.Request {
  struct getTodosFilteredRequestDTO: Encodable {

    public let dayOfWeeks: [String]
    public let onboardingIds: [Int]

    public init(dayOfWeeks: [String], onboardingIds: [Int]) {
      self.dayOfWeeks = dayOfWeeks
      self.onboardingIds = onboardingIds
    }
  }
}
