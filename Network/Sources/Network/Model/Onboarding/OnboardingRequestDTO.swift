//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation

public extension OnboardingDTO.Request {

  struct PostNewRoomRequestDTO: Encodable {

    public let name: String
    
    public init(name: String) {
      self.name = name
    }
  }

  struct GetIsExistRoomRequestDTO: Encodable {

    public let code: String

    public init(code: String) {
      self.code = code
    }
  }
}
