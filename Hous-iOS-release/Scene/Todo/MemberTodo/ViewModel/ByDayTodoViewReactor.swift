//
//  ByDayTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import Foundation

import ReactorKit
import Network

final class ByDayTodoViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
  }

  enum Mutation {
    case setTodos
  }

  struct State {
    var todos: [String] = []
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setTodos:
      newState.todos = []
    return newState
    }
  }
}
