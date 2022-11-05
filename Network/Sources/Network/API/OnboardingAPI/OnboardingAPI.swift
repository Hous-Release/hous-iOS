//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation

protocol OnboardingAPIProtocol {
  func postNewRoom(
    _ name: OnboardingDTO.Request.PostNewRoomRequestDTO,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  func postExistRoom(
    _ roomId: Int,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  func getIsExistRoom(
    _ code: OnboardingDTO.Request.GetIsExistRoomRequestDTO,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .CheckExistRoomResponseDTO>?, Error?) -> Void
  )
}

public final class OnboardingAPI: APIRequestLoader<OnboardingService>, OnboardingAPIProtocol {
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


}
