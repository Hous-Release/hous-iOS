//
//  MainHomeDTO.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/10.
//

import Foundation
// MARK: - MainHomeDTO
struct MainHomeDTO: Decodable {
  let homies: [HomieDTO]
  let myTodos: [String]
  let myTodosCnt: Int
  let ourRules: [String]
  let progress: Int
  let roomName: String
  let userNickname: String
  
  
  func toDomain() -> MainHomeModel {
    
    let homieList = self.homies.map({ dto in
      return HomieModel(
        color: dto.color,
        userNickname: dto.userNickname)
    })
    
    return MainHomeModel(
      userNickname: self.userNickname,
      roomName: self.roomName,
      progress: self.progress,
      myTodos: self.myTodos,
      ourRules: self.ourRules,
      homies: homieList
    )
  }
}

// MARK: - Homie
struct HomieDTO: Decodable {
  let color: String
  let homieID: Int
  let userNickname: String
  
  enum CodingKeys: String, CodingKey {
    case color
    case homieID = "homieId"
    case userNickname
  }
}
