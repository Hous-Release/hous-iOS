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

extension SearchModel {

  static func dummy() -> [SearchModel] {
    return [
      SearchModel(isNew: true, id: 1, name: "투두1"),
      SearchModel(isNew: true, id: 2, name: "아"),
      SearchModel(isNew: true, id: 3, name: "안녕"),
      SearchModel(isNew: true, id: 4, name: "안녕하세요"),
      SearchModel(isNew: true, id: 5, name: "안녕안녕하세요"),
      SearchModel(isNew: true, id: 6, name: "아리랑아라리오"),
      SearchModel(isNew: true, id: 7, name: "투두2"),
      SearchModel(isNew: true, id: 8, name: "투두3"),
      SearchModel(isNew: true, id: 9, name: "투두4"),
      SearchModel(isNew: true, id: 10, name: "투두5"),
      SearchModel(isNew: true, id: 11, name: "투두6"),
      SearchModel(isNew: true, id: 12, name: "김지현김지현"),
      SearchModel(isNew: true, id: 13, name: "김지김지"),
      SearchModel(isNew: true, id: 14, name: "가나다라마바"),
      SearchModel(isNew: true, id: 15, name: "가나다"),
      SearchModel(isNew: true, id: 16, name: "ㄱ")
    ]
  }
}
