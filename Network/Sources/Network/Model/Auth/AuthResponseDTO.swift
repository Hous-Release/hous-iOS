//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

public extension AuthDTO.Response {
  struct LoginResponseDTO: Decodable {

    public let token: Token
    public let isJoiningRoom: Bool

    enum CodingKeys: String, CodingKey {
      case token
      case isJoiningRoom
    }
  }
}
