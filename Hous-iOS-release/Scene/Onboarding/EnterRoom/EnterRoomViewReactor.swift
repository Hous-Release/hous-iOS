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
    case didTapExistRoomButton(code: String?)
  }

  enum Mutation {
    case setNewRoomTransition
    case setExistRoomTransition(code: String?)
  }

  struct State {
    var newRoomTransition: Bool = false
    var existRoomTransition: (Bool, String?) = (false, nil)
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapNewRoomButton:
      return .just(Mutation.setNewRoomTransition)
    case .didTapExistRoomButton(let code):
      if let code {
        return .just(Mutation.setExistRoomTransition(code: code))
      }
      return .just(Mutation.setExistRoomTransition(code: nil))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    newState.newRoomTransition = false
    newState.existRoomTransition = (false, nil)
    switch mutation {
    case .setNewRoomTransition:
      newState.newRoomTransition = !currentState.newRoomTransition
    case .setExistRoomTransition(let code):
      if let code {
        newState.existRoomTransition = (!currentState.existRoomTransition.0, code)
      } else {
        newState.existRoomTransition = (!currentState.existRoomTransition.0, nil)
      }
      
      
    }
    return newState
  }
}
