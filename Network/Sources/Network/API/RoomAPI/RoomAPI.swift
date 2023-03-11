//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation

protocol RoomAPIProtocol {

  // 온보딩 - 방생성
  func postNewRoom(
    _ name: OnboardingDTO.Request.PostNewRoomRequestDTO,
    completion: @escaping
    (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  // 온보딩 - 방참여
  func postExistRoom(
    _ roomId: Int,
    completion: @escaping
    (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  // 온보딩 - 참가하려는 방 정보 조회
  func getIsExistRoom(
    _ code: OnboardingDTO.Request.GetIsExistRoomRequestDTO,
    completion: @escaping
    (BaseResponseType<OnboardingDTO.Response
      .CheckExistRoomResponseDTO>?, Error?) -> Void
  )
  // 홈 - 방 별명 수정
  func updateRoomName(
    _ roomRequestDTO: RoomDTO.Request.updateRoomNameRequestDTO,
    completion: @escaping (BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>?, Error?) -> Void
  )
 // 퇴사 - 방 퇴사
  func leaveRoom(
    completion: @escaping (BaseResponseType<String>?, Error?) -> Void
  )
}

public final class RoomAPI: APIRequestLoader<RoomService>, RoomAPIProtocol {

  public func postNewRoom(_ name: OnboardingDTO.Request.PostNewRoomRequestDTO, completion: @escaping (BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .postNewRoom(name),
      responseData: BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }

  public func postExistRoom(_ roomId: Int, completion: @escaping (BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .postExistRoom(roomId),
      responseData: BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }

  public func getIsExistRoom(_ code: OnboardingDTO.Request.GetIsExistRoomRequestDTO, completion: @escaping (BaseResponseType<OnboardingDTO.Response.CheckExistRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .getIsExistRoom(code),
      responseData: BaseResponseType<OnboardingDTO.Response.CheckExistRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }

  public func updateRoomName(_ roomRequestDTO: RoomDTO.Request.updateRoomNameRequestDTO, completion: @escaping (BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>?, Error?) -> Void) {
    fetchData(target: .updateRoomName(roomRequestDTO), responseData: BaseResponseType<RoomDTO.Response.updateRoomNameResponseDTO>.self, isWithInterceptor: true) { res, err in
      completion(res, err)
    }
  }

  public func leaveRoom(completion: @escaping (BaseResponseType<String>?, Error?) -> Void) {
    fetchData(target: .leaveRoom, responseData: BaseResponseType<String>.self, isWithInterceptor: true) { res, err in
      completion(res, err)
    }
  }

}
