//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation

public extension RoomDTO.Request {
  struct updateRoomNameRequestDTO: Encodable {

    public let name: String
    
    public init(name: String) {
      self.name = name
    }
  }
}
