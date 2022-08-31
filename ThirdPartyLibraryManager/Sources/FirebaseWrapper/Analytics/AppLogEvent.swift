//
//  File.swift
//  
//
//  Created by 김호세 on 2022/08/28.
//

import Foundation

public enum AppLogEvent: String {
  case appStart
  case didTapButton
}

extension AppLogEvent {
  public var rawValue: String {
    switch self {
    case .appStart: return "AppStart"
    case .didTapButton: return "didTapButton"
    }
  }
}

public enum AppLogEventAttribute: String {
  case itemID = "itemID"
  case itemName = "itemName"
  case contentType = "contentType"
}
