//
//  TodoHomieModel.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation
import UIKit

struct UpdateTodoHomieModel: Hashable {
  enum Day: Int, Hashable, CaseIterable, CustomStringConvertible, Comparable {
    case mon, tue ,wed ,thu ,fri ,sat ,sun
  }

  let name: String
  let color: UIColor
  let selectedDay: [Day]
  private let identifier = UUID()
}

extension UpdateTodoHomieModel.Day {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  var description: String {
    switch self {
    case .mon:
      return "월"
    case .tue:
      return "화"
    case .wed:
      return "수"
    case .thu:
      return "목"
    case .fri:
      return "금"
    case .sat:
      return "토"
    case .sun:
      return "일"
    }
  }
}
