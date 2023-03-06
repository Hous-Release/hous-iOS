//
//  TodoHomieModel.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation
import UIKit

// MARK: - TodoUser에 대응함.
public struct UpdateTodoHomieModel: Hashable {
  public enum Day: Int, Hashable, CaseIterable, CustomStringConvertible, Comparable {
    case mon, tue, wed, thu, fri, sat, sun
  }

  let name: String
  let color: HomieColor
  var selectedDay: [Day]
  let onboardingID: Int
  var isExpanded: Bool
  private let identifier = UUID()
}

extension UpdateTodoHomieModel.Day {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
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
  public var asDTO: String {
    switch self {
    case .mon:
      return "MONDAY"
    case .tue:
      return "TUESDAY"
    case .wed:
      return "WEDNESDAY"
    case .thu:
      return "THURSDAY"
    case .fri:
      return "FRIDAY"
    case .sat:
      return "SATURDAY"
    case .sun:
      return "SUNDAY"
    }
  }
}
extension String {
  func returnDay() -> UpdateTodoHomieModel.Day? {
    switch self {
    case "월":
      return .mon
    case "화":
      return .tue
    case "수":
      return .wed
    case "목":
      return .thu
    case "금":
      return .fri
    case "토":
      return .sat
    case "일":
      return .sun
    default:
      return nil
    }
  }
}
