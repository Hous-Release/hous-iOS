//
//  SignInType.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation

enum SignInType: CustomStringConvertible {
  case Apple
  case Kakao

  var description: String {

    switch self {
    case .Apple: return "APPLE"
    case .Kakao: return "KAKAO"
    }
  }
}
