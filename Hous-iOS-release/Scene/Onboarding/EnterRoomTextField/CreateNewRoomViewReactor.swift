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

  enum Action {
    case enterRoomName(String)
    case tapCreateRoom
  }

  enum Mutation {
    case setRoomName(String)
    case setRoomNameCount(String)
    case setIsButtonEnable(Bool)
    case setViewTransition(Bool)
  }

  struct State {
    var roomName: String = ""
    var roomNameCount: String = ""
    var isButtonEnable: Bool = false
    var viewTransition: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .enterRoomName(roomName):
      return .concat([
        limitMaxLength(of: roomName),
        countToString(of: roomName),
        .just(Mutation.setIsButtonEnable(roomName.count > 0))
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

extension CreateNewRoomViewReactor {

  private func limitMaxLength(of nickname: String) -> Observable<Mutation> {

    let limitedText = nickname.prefix(8)

    return .just(.setRoomName(String(limitedText)))
  }

  private func countToString(of roomName: String) -> Observable<Mutation> {
    var count = roomName.count
    if count > 8 { count = 8 }
    let labelText = "\(String(count)) / 8"
    return .just(Mutation.setRoomNameCount(labelText))
  }
}
