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
        self.limitMaxLength(of: roomName),
        self.countToString(of: roomName),
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

  private func limitMaxLength(of roomName: String) -> Observable<Mutation> {
    /// Question : 이렇게 하면.. prev이 업뎃이 안되네
    Observable.of(roomName)
      .scan("") { prev, next in
        print("prev : \(prev), next : \(next)")
        return next.count > 8 ? prev : next
      }
      .map { Mutation.setRoomName($0) }
  }

  private func countToString(of roomName: String) -> Observable<Mutation> {
    var count = roomName.count
    count > 8 ? count = 8 : nil
    let labelText = "\(String(count)) / 8"
    return .just(Mutation.setRoomNameCount(labelText))
  }
}
