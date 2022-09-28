//
//  MyTodoCollectionViewCellReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/17.
//

import Foundation

import RxSwift
import ReactorKit

final class MyTodoCollectionViewCellReactor: Reactor {

  enum Action {
    case check(Bool)
  }

  enum Mutation {
    case setCheckStatus(Bool)
  }

  struct State {
    var isChecked: Bool = true
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .check(isChecked):
      return .just(Mutation.setCheckStatus(isChecked))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setCheckStatus(isChecked):
      newState.isChecked = !isChecked
    }
    return newState
  }
}
