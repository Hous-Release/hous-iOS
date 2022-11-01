//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation
import UIKit

public struct CopyCodePopUpModel {
  public init(
    image: String,
    actionText: String,
    subtitle: String
  ) {
    self.image = image
    self.actionText = actionText
    self.subtitle = subtitle
  }

  public let image: String
  public let actionText: String
  public let subtitle: String

}
