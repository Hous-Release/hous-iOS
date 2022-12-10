//
//  UserRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/10.
//

import Foundation
import Network
import RxSwift

public enum UserRepositoryEvent {
  case isResignSuccess(Bool)
  case sendError(HouseErrorModel?)
}

public protocol UserRepository {
  var event: PublishSubject<UserRepositoryEvent> { get }

  func deleteUser(_ dto: UserDTO.Request.DeleteUserRequestDTO)
}
public final class UserRepositoryImp: BaseService, UserRepository {
  public var event = PublishSubject<UserRepositoryEvent>()

  public func deleteUser(_ dto: UserDTO.Request.DeleteUserRequestDTO) {

    NetworkService.shared.userRepository.deleteUser(dto) { [weak self] res, err in
      guard let self = self else { return }
      guard
        let isSuccess = res?.success,
        isSuccess
      else {
        let errorModel = HouseErrorModel(
          success: res?.success,
          status: res?.status,
          message: res?.message
        )
        self.event.onNext(.isResignSuccess(false))
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.isResignSuccess(true))
    }
  }

}
