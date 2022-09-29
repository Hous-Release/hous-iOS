//
//  EnterRoomCodeViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit
import RxCocoa
import ReactorKit

final class EnterRoomCodeViewReactor: Reactor {

  /*
   Action
   1. textfield text
   2. enterButton Tap

   State
   1. server + isValidCode - > yes : view transition & no : errorLabel ishidden false
   */

  enum Action {
    case enterRoomCode(String)
    case tapEnterRoom
  }

  enum Mutation {
    case setIsButtonEnable(Bool)
    case setIsValidCode(Bool)
    case setViewTransition(Bool)
  }

  struct State {
    var isButtonEnable: Bool = false
    var isValidCode: Bool = true
    var viewTransition: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .enterRoomCode(code):
      return .concat([
        .just(Mutation.setIsButtonEnable(code.count > 0)),
        // 서버통신 이후 결과
        .just(Mutation.setIsValidCode(true))
      ])
    case .tapEnterRoom:
      // 서버통신
      return .just(Mutation.setViewTransition(true))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    switch mutation {
    case let .setIsButtonEnable(status):
      newState.isButtonEnable = status
    case let .setIsValidCode(status):
      newState.isValidCode = status
    case let .setViewTransition(status):
      newState.viewTransition = status
    }
    return newState
  }
}

extension EnterRoomCodeViewReactor {

}
