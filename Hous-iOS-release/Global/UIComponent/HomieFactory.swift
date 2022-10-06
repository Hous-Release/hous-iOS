//
//  HomieFactory.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/06.
//

import UIKit

enum HomieColor: String {
  case YELLOW, RED, BLUE, PURPLE, GREEN, GRAY
}

protocol HomieProtocol {
  var color: UIColor { get set }
  var profileBackgroundImage: UIImage { get set }
}

struct YellowHomie: HomieProtocol {
  var color = Colors.yellow.color
  var profileBackgroundImage = Images.profileYellow.image
}

struct BlueHomie: HomieProtocol {
  var color = Colors.blue.color
  var profileBackgroundImage = Images.profileBlue.image
}

struct PurpleHomie: HomieProtocol {
  var color = Colors.purple.color
  var profileBackgroundImage = Images.profilePurple.image
}

struct RedHomie: HomieProtocol {
  var color = Colors.red.color
  var profileBackgroundImage = Images.profileRed.image
}

struct GreenHomie: HomieProtocol {
  var color = Colors.green.color
  var profileBackgroundImage = Images.profileGreen.image
}

struct GrayHomie: HomieProtocol {
  var color = Colors.g4.color
  var profileBackgroundImage = Images.profilePurple.image
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

