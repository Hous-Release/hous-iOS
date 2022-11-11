//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import Foundation

public struct TodoModel {

  let homies: [HomieCellModel]
  let todoName: String
  let days: [Days]

  public init(
    homies: [HomieCellModel],
    todoName: String,
    days: [Days]
  ) {
    self.homies = homies
    self.todoName = todoName
    self.days = days
  }
}
