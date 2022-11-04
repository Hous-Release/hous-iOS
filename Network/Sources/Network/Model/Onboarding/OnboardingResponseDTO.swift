//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation

public extension OnboardingDTO.Response {
  // MARK: - 방 입장 및 생성 완료
  struct EnterRoomResponseDTO: Decodable {
    public let roomCode: String
    public let roomId: Int
  }

  // MARK: - 방 정보 조회
  struct CheckExistRoomResponseDTO: Decodable {
    public let nickname: String
    public let roomId: Int
  }
}
