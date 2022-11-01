//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation

public struct DefaultPopUpModel {
  public init(
    cancelText: String,
    actionText: String,
    title: String,
    subtitle: String
  ) {
    self.cancelText = cancelText
    self.actionText = actionText
    self.title = title
    self.subtitle = subtitle
  }

  public let cancelText: String
  public let actionText: String
  public let title: String
  public let subtitle: String

}
