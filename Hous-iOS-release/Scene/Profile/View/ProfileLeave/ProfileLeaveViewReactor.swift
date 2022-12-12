//
//  ProfileLeaveViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit
import ReactorKit
import Network

class ProfileLeaveViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
  }

  enum Mutation {
    case setError(String?)
  }

  struct State {
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .fetch:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setError(error):
      newState.error = error
    }

    return newState
  }

//  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//
//  }
}
