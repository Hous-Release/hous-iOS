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

  enum Action {
    case didTapSignIn(SignInType)
    case login(accessToken: String?, error: Error?)
    case resetError
  }

  enum Mutation {
    case setSignInType(SignInType)
    case setError(String?)
    case setIsSuccess(Bool)
  }

  struct State {
    var signinType: SignInType? = nil
    var error: String? = nil
    var isSuccessLogin: Bool = false
  }

  let initialState: State = State()

  private let authoRepository: AuthRepository = AuthRepositoryImp()

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

      return .empty()

    case .resetError:
      return .just(.setError(nil))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {

    case .setSignInType(let signInType):
      newState.signinType = signInType

    case .setError(let error):
      newState.error = error

    case .setIsSuccess(let isSuccess):
      newState.isSuccessLogin = isSuccess

    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = authoRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .isSuccess(let isSuccess):
        return .just(.setIsSuccess(isSuccess))

      case .updateAccessToken(let accessToken):
        Keychain.shared.setAccessToken(accessToken: accessToken)
        return .empty()

      case .updateRefreshToken(let refreshToken):
        Keychain.shared.setRefreshToken(refreshToken: refreshToken)
        return .empty()

      case .sendError(let errorModel):
        return .just(.setError(errorModel?.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }

}

extension SignInReactor {
  private func login(_ dto: AuthDTO.Request.LoginRequestDTO) {
    authoRepository.login(dto)
  }
}
