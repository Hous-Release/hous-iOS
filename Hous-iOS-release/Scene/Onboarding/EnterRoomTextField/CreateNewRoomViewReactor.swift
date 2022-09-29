//
//  CreateNewRoomViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit
import RxCocoa
import ReactorKit

final class CreateNewRoomViewReactor: Reactor {

  /*
   Action
   1. textfield text
   2. createButton Tap

   State
   1. textfield text max length
   2. textfield text count
   3. createButton tap view transition + server
   */

  enum Action {
    case enterRoomName(String)
    case tapCreateRoom
  }

  enum Mutation {
    case setRoomName(String)
    case setRoomNameCount(Int)
    case setIsButtonEnable(Bool)
    case setViewTransition(Bool)
  }

  struct State {
    var roomName: String = ""
    var roomNameCount: Int = 0
    var isButtonEnable: Bool = false
    var viewTransition: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .enterRoomName(roomName):
      return .concat([
        .just(Mutation.setRoomName(roomName)),
        .just(Mutation.setRoomNameCount(roomName.count)),
        .just(Mutation.setIsButtonEnable(true))
      ])
    case .tapCreateRoom:
      return .just(Mutation.setViewTransition(true))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    switch mutation {
    case let .setRoomName(roomName):
      newState.roomName = roomName
    case let .setRoomNameCount(count):
      newState.roomNameCount = count
    case let .setIsButtonEnable(status):
      newState.isButtonEnable = status
    case let .setViewTransition(status):
      newState.viewTransition = status
    }
    return newState
  }
}
