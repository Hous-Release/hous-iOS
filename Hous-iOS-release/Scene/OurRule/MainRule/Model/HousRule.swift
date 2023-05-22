//
//  HousRule.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/13.
//

import Foundation

public struct HousRule: Hashable {
  let id: Int
  let name: String
  let identifier = UUID()

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func dummy() -> [HousRule] {
    return [
      HousRule(id: 1, name: "김민재"),
      HousRule(id: 2, name: "규칙"),
      HousRule(id: 3, name: "손흥민"),
      HousRule(id: 4, name: "민김재"),
      HousRule(id: 5, name: "민김김김"),
      HousRule(id: 6, name: "민민민민민김"),
      HousRule(id: 7, name: "민민김"),
      HousRule(id: 8, name: "김민김"),
      HousRule(id: 9, name: "요아소비"),
      HousRule(id: 10, name: "ㄱㄱㄱㄱㄱ"),
      HousRule(id: 11, name: "김ㄱㄱㄱ"),
      HousRule(id: 12, name: "김김ㄱㄱ"),
      HousRule(id: 13, name: "기리릴ㄱ")
    ]
  }

  public static func == (lhs: HousRule, rhs: HousRule) -> Bool {
    return lhs.identifier == rhs.identifier
  }

  func contains(_ filter: String?) -> Bool {
    guard let filterText = filter else { return true }
    if filterText.isEmpty { return true }
    let lowercasedFilter = filterText.lowercased()

    return name.lowercased().contains(lowercasedFilter)
  }
}
