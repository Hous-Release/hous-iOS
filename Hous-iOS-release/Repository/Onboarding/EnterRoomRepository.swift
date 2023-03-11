//
//  EnterRoomRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation
import Network
import RxSwift
import RxCocoa


public enum EnterRoomRepositoryEvent {
  case roomHostNickname(String?)
  case roomCode(String?)
  case roomId(Int?)
  case sendError(HouseErrorModel?)
}

public protocol EnterRoomRepository {
  var event: PublishSubject<EnterRoomRepositoryEvent> { get }

  func enterNewRoom(_ name: String)
  func enterExistRoom(_ roomId: Int)
  func checkExistRoom(_ code: String)
}
public final class EnterRoomRepositoryImp: BaseService, EnterRoomRepository {
  public var event = PublishSubject<EnterRoomRepositoryEvent>()

  public func enterNewRoom(_ name: String) {

    let dto = OnboardingDTO.Request.PostNewRoomRequestDTO(name: name)
    NetworkService.shared.roomRepository.postNewRoom(dto) { [weak self] res, err in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.roomCode(data.roomCode))
      self.event.onNext(.roomId(data.roomId))
    }
  }

  public func enterExistRoom(_ roomId: Int) {

    NetworkService.shared.roomRepository.postExistRoom(roomId) { [weak self] res, err in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )

        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.roomCode(data.roomCode))
      self.event.onNext(.roomId(data.roomId))
    }
  }

  public func checkExistRoom(_ code: String) {
    let dto = OnboardingDTO.Request.GetIsExistRoomRequestDTO(code: code)
    NetworkService.shared.roomRepository.getIsExistRoom(dto) { [weak self] res, err in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )
        self.event.onNext(.sendError(errorModel))
        return
      }
      self.event.onNext(.roomHostNickname(data.nickname))
      self.event.onNext(.roomId(data.roomId))
    }
  }

}
