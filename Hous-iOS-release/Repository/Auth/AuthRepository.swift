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


public enum AuthRepositroyEvent {
  case isSuccess(Bool)
  case updateAccessToken(String)
  case updateRefreshToken(String)
  case sendError(HouseErrorModel?)
}

public protocol AuthRepository {
  var event: PublishSubject<AuthRepositroyEvent> { get }

  func login(_ dto: AuthDTO.Request.LoginRequestDTO)
  func refresh(_ dto: Token)
}
public final class AuthRepositoryImp: AuthRepository {
  public var event = PublishSubject<AuthRepositroyEvent>()

  public func login(_ dto: AuthDTO.Request.LoginRequestDTO) {

    NetworkService.shared.authRepository.login(dto) { [weak self] res, err in
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
      self.event.onNext(.isSuccess(true))

    }
  }

  public func refresh(_ dto: Token) {
    NetworkService.shared.authRepository.refresh(dto) { [weak self] res, err in
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

      self.event.onNext(.isSuccess(true))
      self.event.onNext(.updateAccessToken(data.accessToken))
      self.event.onNext(.updateRefreshToken(data.refreshToken))

    }
  }

}

