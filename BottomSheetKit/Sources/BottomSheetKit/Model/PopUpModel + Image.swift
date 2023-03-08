//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import AssetKit
import Foundation
import UIKit

public struct ImagePopUpModel {
  public init(
    image: PopUpImage,
    actionText: String,
    text: String,
    titleText: String? = nil
  ) {
    self.image = image
    self.actionText = actionText
    self.text = text
    self.titleText = titleText
  }

  public let image: PopUpImage
  public let actionText: String
  public let text: String
  public let titleText: String?

}

public enum PopUpImage {
  case test
  case exceed
  case welcome
  case needUpdate
  case url(String)

  func setImage(to uiImageView: UIImageView) {
    switch self {
      // TODO: -
    case .test:
      uiImageView.image = Images.badgeLock.image
    case .exceed:
      // TODO: 해당하는 이미지 넣기
      uiImageView.image = Images.illLimit.image
    case .welcome:
      uiImageView.image = Images.illGo.image

    case .needUpdate:
      uiImageView.image = Images.invalidName.image

    case .url( _):
      // TODO: - 킹피셔
      break
    }
  }
}
