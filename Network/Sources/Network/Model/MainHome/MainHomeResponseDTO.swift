//
//  MainHomeResponseDTO.swift
//  
//
//  Created by 김민재 on 2022/09/23.
//

public extension MainHomeDTO.Response {
  struct MainHomeResponseDTO: Decodable {
    public let homies: [HomieDTO]
    public let myTodos: [String]
    public let myTodosCnt: Int
    public let ourRules: [String]
    public let progress: Int
    public let roomCode: String
    public let roomName: String
    public let userNickname: String
  }
  
  struct HomieDTO: Decodable {
    public let color: String
    public let homieID: Int
    public let userNickname: String
    
    enum CodingKeys: String, CodingKey {
      case color
      case homieID = "homieId"
      case userNickname
    }
  }
}
