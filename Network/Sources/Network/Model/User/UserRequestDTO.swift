//
//  File.swift
//  
//
//  Created by 김지현 on 2022/12/10.
//

import Foundation

public extension UserDTO.Request {
    struct DeleteUserRequestDTO: Encodable {

      public let comment: String
      public let feedbackType: String

      public init(comment: String, feedbackType: String) {
        self.comment = comment
        self.feedbackType = feedbackType
      }
    }
}
