//
//  AuthRepository.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/23.
//

import Foundation
import Network
import RxSwift
import RxCocoa

public enum AuthRepositoryEvent {
  case isJoiningRoom(Bool)
  case updateAccessToken(String)
  case updateRefreshToken(String)
  case logout
  case sendError(HouseErrorModel?)
}

public protocol AuthRepository {
  var event: PublishSubject<AuthRepositoryEvent> { get }

  func login(_ dto: AuthDTO.Request.LoginRequestDTO)
  func forceLogin(_ dto: AuthDTO.Request.LoginRequestDTO)
  func refresh(_ accessToken: String, _ refreshToken: String)
  func signup(_ dto: AuthDTO.Request.SignupRequestDTO)
  func logout()
}
public final class AuthRepositoryImp: BaseService, AuthRepository {
  public var event = PublishSubject<AuthRepositoryEvent>()

  public func logout() {
    NetworkService.shared.authRepository.logout { [weak self] res, _ in
      guard let self = self else { return }
      guard res?.data != nil else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )

        self.event.onNext(.sendError(errorModel))
        return
      }
    }
  }

  public func forceLogin(_ dto: AuthDTO.Request.LoginRequestDTO) {

    NetworkService.shared.authRepository.forceLogin(dto) { [weak self] res, _ in
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

      self.event.onNext(.updateAccessToken(data.token.accessToken))
      self.event.onNext(.updateRefreshToken(data.token.refreshToken))

      self.event.onNext(.isJoiningRoom(data.isJoiningRoom))

    }
  }

  public func login(_ dto: AuthDTO.Request.LoginRequestDTO) {

    NetworkService.shared.authRepository.login(dto) { [weak self] res, _ in
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

      self.event.onNext(.updateAccessToken(data.token.accessToken))
      self.event.onNext(.updateRefreshToken(data.token.refreshToken))

      self.event.onNext(.isJoiningRoom(data.isJoiningRoom))

    }
  }

  public func refresh(_ accessToken: String, _ refreshToken: String) {

    let dto = Token(accessToken: accessToken, refreshToken: refreshToken)

    NetworkService.shared.authRepository.refresh(dto) { [weak self] res, _ in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success,
          status: res?.status,
          message: res?.message
        )

        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.updateAccessToken(data.token.accessToken))
      self.event.onNext(.updateRefreshToken(data.token.refreshToken))

      self.event.onNext(.isJoiningRoom(data.isJoiningRoom))

    }
  }

  public func signup(_ dto: AuthDTO.Request.SignupRequestDTO) {

    NetworkService.shared.authRepository.signup(dto) { [weak self] res, _ in

      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success,
          status: res?.status,
          message: res?.message
        )

        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.updateAccessToken(data.token.accessToken))
      self.event.onNext(.updateRefreshToken(data.token.refreshToken))

      self.event.onNext(.isJoiningRoom(data.isJoiningRoom))
    }
  }

}
