//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation

protocol RoomAPIProtocol {

  func updateRoomName(
    _ roomRequestDTO: RoomDTO.Request.updateRoomNameRequestDTO,
    completion: @escaping (BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>?, Error?) -> Void
  )
}

public final class RoomAPI: APIRequestLoader<RoomService>, RoomAPIProtocol {
    public func updateRoomName(_ roomRequestDTO: RoomDTO.Request.updateRoomNameRequestDTO, completion: @escaping (BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>?, Error?) -> Void) {
        fetchData(target: .updateRoomName(roomRequestDTO), responseData: BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>.self, isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
    
  
}
