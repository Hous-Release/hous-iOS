//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

public extension AuthDTO.Request {
  struct LoginRequestDTO: Encodable {

    public let fcmToken: String
    public let socialType: String
    // MARK: - Access Token For Auth login
    public let token: String

    public init(
      fcmToken: String,
      socialType: String,
      token: String
    ) {
      self.fcmToken = fcmToken
      self.socialType = socialType
      self.token = token
    }

  }

  struct SignupRequestDTO: Encodable {
    
    public let birthday: String
    public let fcmToken: String
    public let isPublic: Bool
    public let nickname: String
    public let socialType: String
    public let token: String

    public init(
      birthday: String,
      fcmToken: String,
      isPublic: Bool,
      nickname: String,
      socialType: String,
      token: String
    ) {
      self.birthday = birthday
      self.fcmToken = fcmToken
      self.isPublic = isPublic
      self.nickname = nickname
      self.socialType = socialType
      self.token = token
    }
  }
}
