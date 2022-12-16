//
//  SignInReactor.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import Network
import ReactorKit
import UserInformation

final class SignInReactor: Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }


  enum Action {
    case didTapSignIn(SignInType)
    case login(accessToken: String?, error: Error?)
    case forceLogin
    case initial
  }

  enum Mutation {
    case setOAuthToken(String?)
    case setSignInType(SignInType?)
    case setError(String?)
    case setIsJoingingRoom(Bool?)
    case setEnterInformationFlag(Bool?)
    case setInitial
    case setDuplicateLogin(Bool)
  }

  struct State {
    var signinType: SignInType?
    var error: String? = nil
    var isJoingingRoom: Bool?
    var oauthToken: String?
    var enterInformationFlag: Bool?
    @Pulse
    var isDuplicateLogin: Bool?
  }

  let initialState: State = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .didTapSignIn(let signType):
      return .just(.setSignInType(signType))

    case .login(let accessToken, let error):

      if let error = error {
        return .just(.setError(error.localizedDescription))
      }

      guard
        let accessToken = accessToken,
        let signinType = currentState.signinType
      else {
        return .empty()
      }

      let loginRequestDTO = AuthDTO.Request.LoginRequestDTO(
        fcmToken: Keychain.shared.getFCMToken() ?? "",
        socialType: signinType.description,
        token: accessToken
      )

      login(loginRequestDTO)
      return .just(.setOAuthToken(accessToken))

    case .forceLogin:
      guard
        let accessToken = currentState.oauthToken,
        let signinType = currentState.signinType
      else {
        return .empty()
      }
      let loginRequestDTO = AuthDTO.Request.LoginRequestDTO(
        fcmToken: Keychain.shared.getFCMToken() ?? "",
        socialType: signinType.description,
        token: accessToken
      )

      forceLogin(loginRequestDTO)
      return .just(.setOAuthToken(accessToken))

    case .initial:
      return .just(.setInitial)

    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {

    case .setSignInType(let signInType):
      newState.signinType = signInType

    case .setError(let error):
      newState.error = error

    case .setIsJoingingRoom(let isJoingingRoom):
      newState.isJoingingRoom = isJoingingRoom

    case .setOAuthToken(let oauthToken):
      newState.oauthToken = oauthToken

    case .setEnterInformationFlag(let isGoingEnterInfo):
      newState.enterInformationFlag = isGoingEnterInfo

    case .setInitial:
      newState = initialState
    case .setDuplicateLogin(let isDuplicateLogin):
      newState.isDuplicateLogin = isDuplicateLogin
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.authRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .logout:
        return .empty()
        
      case .isJoiningRoom(let isJoingingRoom):
        return .just(.setIsJoingingRoom(isJoingingRoom))

      case .updateAccessToken(let accessToken):
        Keychain.shared.setAccessToken(accessToken: accessToken)
        return .empty()

      case .updateRefreshToken(let refreshToken):
        Keychain.shared.setRefreshToken(refreshToken: refreshToken)
        return .empty()

      case .sendError(let errorModel):
        guard
          let errorModel = errorModel,
          let statusCode = errorModel.status
        else {
          return .empty()
        }

        if statusCode == 404 {
          return .just(.setEnterInformationFlag(true))
        }
        if statusCode == 409 {
          return .just(.setDuplicateLogin(true))
        }

        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }

}

extension SignInReactor {
  private func login(_ dto: AuthDTO.Request.LoginRequestDTO) {
    provider.authRepository.login(dto)
  }
  private func forceLogin(_ dto: AuthDTO.Request.LoginRequestDTO) {
    provider.authRepository.forceLogin(dto)
  }
}
