//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import Foundation

public enum Days: Int, Hashable, CaseIterable, CustomStringConvertible, Comparable {
  public static func < (lhs: Days, rhs: Days) -> Bool {
    lhs.rawValue < rhs.rawValue
  }

  case mon
  case tue
  case wed
  case thu
  case fri
  case sat
  case sun

  public var description: String {
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
