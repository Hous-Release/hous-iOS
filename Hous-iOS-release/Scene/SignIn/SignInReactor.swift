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
    case login
  }
  enum Mutation {

  }

  struct State {
    var signinType: SignInType? = nil

  }

  let initialState: State = State()


  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .didTapSignIn(let signType):
      return .empty()
    case .login:
      return .empty()
    }



  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {

    }

    return newState
  }



}
