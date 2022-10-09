//
//  PopUpModel.swift
//  
//
//  Created by 김호세 on 2022/10/10.
//

import Foundation
import UIKit

public struct PopUpModel {
  public let popUpType: PopUpType

  public init(popUpType: PopUpType) {
    self.popUpType = popUpType
  }
}

public enum PopUpType {
  case twoButton(cancelText: String, actionText: String)
  case oneButtonWithImage(actionText: String, image: UIImage)
}

// TODO: TwoButton Model 만들기
// TODO: OneButton Image 만들기
