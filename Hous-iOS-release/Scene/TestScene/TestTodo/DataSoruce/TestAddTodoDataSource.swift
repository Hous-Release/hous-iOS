//
//  TestAddTodoDataSource.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/13.
//

import Foundation

public enum TestAddTodoDataSource { }

extension TestAddTodoDataSource {
  enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
    case assignee
    case individual

    var description: String {
      switch self {
      case .assignee:
        return "담당자"
      case .individual:
        return "Individual"
      }
    }

  }

  struct Item: Hashable {
    let homie: TestHomie?
    let hasChild: Bool
    private let identifier = UUID()

    init(homie: TestHomie?, hasChild: Bool) {
      self.hasChild = hasChild
      self.homie = homie
    }
  }
}
