//
//  ResignViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit
import ReactorKit

class ResignViewReactor: ReactorKit.Reactor {

  enum Action {
    case didTapCheck
    case didTapResign
    case didSelectResignReason(String?)
  }

  enum Mutation {
    case setIsCheckButtonSelected(Bool)
    case setIsResignButtonClicked(Bool?)
    case setResignReason(String?)
  }

  struct State {
    var isCheckButtonSelected: Bool = false
    @Pulse
    var isResignButtonClicked: Bool?
    var resignReason: String?
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:
      return .just(Mutation.setIsCheckButtonSelected(!currentState.isCheckButtonSelected))
    case .didTapResign:
      return .empty()
    case let .didSelectResignReason(reason):
      return .just(Mutation.setResignReason(reason))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setIsCheckButtonSelected(flag):
      newState.isCheckButtonSelected = flag
    case let .setIsResignButtonClicked(flag):
      newState.isResignButtonClicked = flag
    case let .setResignReason(reason):
      newState.resignReason = reason
    }

    return newState
  }
}
