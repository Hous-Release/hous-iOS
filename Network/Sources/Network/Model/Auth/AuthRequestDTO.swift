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
}
