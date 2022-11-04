//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation

protocol OnboardingAPIProtocol {
  func postNewRoom(
    _ requestDTO: OnboardingDTO.Request.CreateNewRoomRequestDTO,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  func postExistRoom(
    _ requestDTO: OnboardingDTO.Request.EnterExistRoomRequestDTO,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .EnterRoomResponseDTO>?, Error?) -> Void
  )
  func getIsExistRoom(
    _ requestDTO: OnboardingDTO.Request.CheckExistRoomRequestDTO,
    completion: @escaping
      (BaseResponseType<OnboardingDTO.Response
      .CheckExistRoomResponseDTO>?, Error?) -> Void
  )
}

public final class OnboardingAPI: APIRequestLoader<OnboardingService>, OnboardingAPIProtocol {
  func postNewRoom(_ requestDTO: OnboardingDTO.Request.CreateNewRoomRequestDTO, completion: @escaping (BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .postNewRoom(requestDTO),
      responseData: BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }

  func postExistRoom(_ requestDTO: OnboardingDTO.Request.EnterExistRoomRequestDTO, completion: @escaping (BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .postExistRoom(requestDTO),
      responseData: BaseResponseType<OnboardingDTO.Response.EnterRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }

  func getIsExistRoom(_ requestDTO: OnboardingDTO.Request.CheckExistRoomRequestDTO, completion: @escaping (BaseResponseType<OnboardingDTO.Response.CheckExistRoomResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .getIsExistRoom(requestDTO),
      responseData: BaseResponseType<OnboardingDTO.Response.CheckExistRoomResponseDTO>.self) { res, err in
        completion(res, err)
      }
  }


}
