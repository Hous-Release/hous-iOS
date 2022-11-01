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
  case defaultPopUp(defaultPopUpModel: DefaultPopUpModel)
  case copyCode(copyPopUpModel: ImagePopUpModel)
}
