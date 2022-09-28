//
//  EnterRoomViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit
import RxCocoa
import ReactorKit

final class EnterRoomViewReactor: Reactor {

  enum Action {
    case didTapNewRoomButton
    case didTapExistRoomButton
  }

  enum Mutation {
    case setNewRoomTransition
    case setExistRoomTransition
  }

  struct State {
    var newRoomTransition: Bool = false
    var existRoomTransition: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapNewRoomButton:
      return .just(Mutation.setNewRoomTransition)
    case .didTapExistRoomButton:
      return .just(Mutation.setExistRoomTransition)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case .setNewRoomTransition:
      newState.newRoomTransition = !currentState.newRoomTransition
    case .setExistRoomTransition:
      newState.existRoomTransition = !currentState.existRoomTransition
    }
    return newState
  }
}
