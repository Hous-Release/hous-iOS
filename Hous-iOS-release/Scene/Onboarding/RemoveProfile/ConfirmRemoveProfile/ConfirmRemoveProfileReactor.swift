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
    case setIsRemoveButtonEnabled(Bool)
    case setIsRemoveButtonClicked(Bool)
    case setError(String?)
  }

  struct State {
    @Pulse var isCheckButtonSelected: Bool = false
    @Pulse var isRemoveButtonEnabled: Bool = false
    @Pulse var isRemoveButtonClicked: Bool = false

    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:

      let newCheckFlag = !currentState.isCheckButtonSelected
      return .concat([
        .just(Mutation.setIsCheckButtonSelected(newCheckFlag)),
        .just(Mutation.setIsRemoveButtonEnabled(newCheckFlag))
      ])

    case .didTapRemoveProfile:
      return .just(Mutation.setIsRemoveButtonClicked(
        !currentState.isRemoveButtonClicked
      ))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setIsCheckButtonSelected(flag):
      newState.isCheckButtonSelected = flag
    case let .setIsRemoveButtonEnabled(flag):
      newState.isRemoveButtonEnabled = flag
    case let .setError(error):
      newState.error = error
    case let .setIsRemoveButtonClicked(flag):
      newState.isRemoveButtonClicked = flag
    }

    return newState
  }


}
