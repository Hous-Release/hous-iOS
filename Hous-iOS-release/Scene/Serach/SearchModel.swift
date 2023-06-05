//
//  SearchModel.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/05.
//

import Foundation

public struct SearchModel: Hashable {
  let isNew: Bool
  let id: Int
  let name: String
  let identifier = UUID()

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  public static func == (lhs: SearchModel, rhs: SearchModel) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  func contains(_ filter: String?) -> Bool {
    guard let filterText = filter else { return true }
    if filterText.isEmpty { return true }
    let lowercasedFilter = filterText.lowercased()

    return name.lowercased().contains(lowercasedFilter)
  }
}
