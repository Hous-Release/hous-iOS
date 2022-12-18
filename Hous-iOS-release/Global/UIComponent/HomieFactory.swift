//
//  HomieFactory.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/06.
//

import UIKit
import AssetKit

enum HomieColor: String, CaseIterable {
  case YELLOW, RED, BLUE, PURPLE, GREEN, GRAY
}

protocol HomieProtocol {
  var color: UIColor { get set }
  var profileBackgroundImage: UIImage { get set }
  var todoMemberChosenImage: UIImage { get set }
  var todoMemberUnchosenImage: UIImage { get set }
  var todoUpdateMemberSelectedImage: UIImage { get set }
  var todoUpdateMemberUnSelectedImage: UIImage { get set }
}

struct YellowHomie: HomieProtocol {
  var color = Colors.yellow.color
  var profileBackgroundImage = Images.profileYellow.image
  var todoMemberChosenImage = Images.icYellowChosen.image
  var todoMemberUnchosenImage = Images.icYellowUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icYellowYes.image
  var todoUpdateMemberUnSelectedImage = Images.icYellowNo.image
}

struct BlueHomie: HomieProtocol {
  var color = Colors.blue.color
  var profileBackgroundImage = Images.profileBlue.image
  var todoMemberChosenImage = Images.icBlueChosen.image
  var todoMemberUnchosenImage = Images.icBlueUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icBlueYes.image
  var todoUpdateMemberUnSelectedImage = Images.icBlueNo.image
}

struct PurpleHomie: HomieProtocol {
  var color = Colors.purple.color
  var profileBackgroundImage = Images.profilePurple.image
  var todoMemberChosenImage = Images.icPurpleChosen.image
  var todoMemberUnchosenImage = Images.icPurpleUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icPurpleYes.image
  var todoUpdateMemberUnSelectedImage = Images.icPurpleNo.image
}

struct RedHomie: HomieProtocol {
  var color = Colors.red.color
  var profileBackgroundImage = Images.profileRed.image
  var todoMemberChosenImage = Images.icRedChosen.image
  var todoMemberUnchosenImage = Images.icRedUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icRedYes.image
  var todoUpdateMemberUnSelectedImage = Images.icRedNo.image
}

struct GreenHomie: HomieProtocol {
  var color = Colors.green.color
  var profileBackgroundImage = Images.profileGreen.image
  var todoMemberChosenImage = Images.icGreenChosen.image
  var todoMemberUnchosenImage = Images.icGreenUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icGreenYes.image
  var todoUpdateMemberUnSelectedImage = Images.icGreenNo.image
}

struct GrayHomie: HomieProtocol {
  var color = Colors.g4.color
  var profileBackgroundImage = Images.profileNone.image
  var todoMemberChosenImage = Images.icGreyChosen.image
  var todoMemberUnchosenImage = Images.icGreyUnchosen.image
  var todoUpdateMemberSelectedImage = Images.icGrayYes.image
  var todoUpdateMemberUnSelectedImage = Images.icGrayNo.image
}

struct HomieFactory {
  
  static func makeHomie(type: HomieColor) -> HomieProtocol {
    switch type {
    case .YELLOW:
      return YellowHomie()
    case .BLUE:
      return BlueHomie()
    case .PURPLE:
      return PurpleHomie()
    case .RED:
      return RedHomie()
    case .GREEN:
      return GreenHomie()
    case .GRAY:
      return GrayHomie()
    }
  }
}

