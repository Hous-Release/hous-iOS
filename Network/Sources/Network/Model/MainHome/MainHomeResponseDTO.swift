//
//  MainHomeResponseDTO.swift
//  
//
//  Created by 김민재 on 2022/09/23.
//

public extension MainHomeDTO.Response {
  struct MainHomeResponseDTO: Decodable {
    let homies: [HomieDTO]
    let myTodos: [String]
    let myTodosCnt: Int
    let ourRules: [String]
    let progress: Int
    let roomName: String
    let userNickname: String
  }
  
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
}
