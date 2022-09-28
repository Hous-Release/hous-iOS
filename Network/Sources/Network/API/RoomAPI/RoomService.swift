//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation
import Alamofire

public enum RoomService {
  case updateRoomName(_ dto: RoomDTO.Request.updateRoomNameRequestDTO)
}

extension RoomService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }
  
  public var path: String {
    switch self {
    case .updateRoomName:
      return "/room/name"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .updateRoomName:
      return .put
    }
  }
  
  public var parameters: RequestParams {
    switch self {
    case let .updateRoomName(dto):
      return .body(dto)
    }
  }
}


