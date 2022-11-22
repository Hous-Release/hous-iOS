//
//  UpdateTodoDataSource.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation

public enum UpdateTodoDataSource { }

extension UpdateTodoDataSource {
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
    var homie: UpdateTodoHomieModel?
    let hasChild: Bool
    private let identifier = UUID()

    init(homie: UpdateTodoHomieModel?, hasChild: Bool) {
      self.hasChild = hasChild
      self.homie = homie
    }
  }
}
