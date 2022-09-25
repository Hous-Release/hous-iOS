//
//  SignInReactor.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import ReactorKit

final class SignInReactor: Reactor {

  enum Action {
    case didTapSignIn(SignInType)
    case login(accessToken: String?, error: Error?)
  }

  enum Mutation {
    case setSignInType(SignInType)
    case setError(String)
    case setIsSuccess(Bool)
  }

  struct State {
    var signinType: SignInType? = nil
    var error: String? = nil
    var isSuccessLogin: Bool = false
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

      if let accessToken = accessToken {

      }

      // TODO: - Network 연결



      return .just(.setIsSuccess(true))

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
}
