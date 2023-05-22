//
//  AddEditRuleDataSource.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/21.
//

import UIKit

struct RulePhoto: Hashable {
  let image: UIImage
  let identifier = UUID()

  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: RulePhoto, rhs: RulePhoto) -> Bool {
    return lhs.identifier == rhs.identifier
  }

}
