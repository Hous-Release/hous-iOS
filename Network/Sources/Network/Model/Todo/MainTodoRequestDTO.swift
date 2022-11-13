//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/13.
//

import Foundation

public extension MainTodoDTO.Request {
  struct updateTodoRequestDTO: Encodable {

    public let status: Bool

    public init(status: Bool) {
      self.status = status
    }
  }
}
