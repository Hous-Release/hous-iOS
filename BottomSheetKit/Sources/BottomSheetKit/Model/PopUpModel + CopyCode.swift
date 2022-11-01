//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation
import UIKit

public struct ImagePopUpModel {
  public init(
    image: String,
    actionText: String,
    text: String
  ) {
    self.image = image
    self.actionText = actionText
    self.text = text
  }

  public let image: String
  public let actionText: String
  public let text: String

}
