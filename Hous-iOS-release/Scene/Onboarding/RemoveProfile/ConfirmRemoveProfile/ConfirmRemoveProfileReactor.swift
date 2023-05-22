//
//  ConfirmRemoveProfileReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import Foundation
import ReactorKit

final class ConfirmRemoveProfileReactor: ReactorKit.Reactor {

  enum Action {
    case didTapCheck
    case didTapRemoveProfile
  }

  enum Mutation {
    case setIsCheckButtonSelected(Bool)
    case setIsRemoveButtonActivated(Bool?)
    case setError(String?)
  }

  struct State {
    var isCheckButtonSelected: Bool = false
    var isRemoveButtonActivated: Bool? = false

    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:
      return .empty()
    case .didTapRemoveProfile:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setIsCheckButtonSelected(flag):
      newState.isCheckButtonSelected = flag
    case let .setIsRemoveButtonActivated(flag):
      newState.isRemoveButtonActivated = flag
    case let .setError(error):
      newState.error = error
    }

    return newState
  }


}
