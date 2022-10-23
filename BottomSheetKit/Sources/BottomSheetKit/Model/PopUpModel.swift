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
  case twoButton(twoButtonPopUpModel: TwoButtonPopUpModel)
  case oneButtonWithImage(actionText: String, image: UIImage)
}



// TODO: TwoButton Model 만들기

public struct TwoButtonPopUpModel {
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
// TODO: OneButton Image 만들기
