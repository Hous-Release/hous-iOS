//
//  SignInType.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation

enum SignInType: CustomStringConvertible {
  case apple
  case kakao

  var description: String {

    switch self {
    case .apple: return "APPLE"
    case .kakao: return "KAKAO"
    }
  }
}
