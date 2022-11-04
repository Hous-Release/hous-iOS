//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation

public extension OnboardingDTO.Request {
  // MARK: - 새로운 방 생성
  struct CreateNewRoomRequestDTO: Encodable {
    public let name: String
    public init(name: String) {
      self.name = name
    }
  }

  // MARK: - 기존 방 입장
  struct CreateNewRoomRequestDTO: Encodable {
    public let roomId: String
    public init(roomId: String) {
      self.roomId = roomId
    }
  }

  // MARK: - 기존 방 입장 전 존재하는 방인지 확인
  struct CheckExistRoomRequestDTO:Encodable {
    public let code: String
    public init(code: String) {
      self.code = code
    }
  }
}
