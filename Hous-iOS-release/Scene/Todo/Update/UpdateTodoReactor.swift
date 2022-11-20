//
//  UpdateReactork.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation
import ReactorKit

public final class UpdateTodoReactor: Reactor {
  private let provider: ServiceProvider
  public let initialState: State

  public init(
    provider: ServiceProvider,
    state: State
  ) {
    self.initialState = state
    self.provider = provider
  }

  public enum Action {
    case fetch
    case enterTodo
    case didTapHomie(IndexPath)
    case didTapDays(IndexPath)
    case didTapUpdate
  }

  public enum Mutation {
    case setNotification(Bool)
    case setTodo(String?)
    case setHomies([UpdateTodoHomieModel])
  }

  public struct State {
    var id: Int? = nil
    var isModifying: Bool = false
    var isPushNotification: Bool = false
    var todo: String? = nil
    var todoHomies: [UpdateTodoHomieModel]
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      if initialState.isModifying {
        provider.todoRepository.fetchModifyingTodo(initialState.id ?? -1)
      }
      return .empty()

    case .enterTodo:
      return .empty()
    case .didTapHomie:
      return .empty()
    case .didTapDays:
      return .empty()
    case .didTapUpdate:
      return .empty()
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setNotification(let notification):
      newState.isPushNotification = notification

    case .setTodo(let todo):
      newState.todo = todo

    case .setHomies(let homies):
      newState.todoHomies = homies

    }

    return newState
  }

}

public extension UpdateTodoReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let service =
      provider.todoRepository.event.flatMap { [weak self] event -> Observable<Mutation> in

      switch event {
      case .getModifyingTodo(let state):
        return Observable.concat([
          .just(.setNotification(state.isPushNotification)),
          .just(.setTodo(state.todo)),
          .just(.setHomies(state.todoHomies))
        ])

      default:
        return .empty()
      }
    }
    return Observable.merge(mutation, service)
  }
}
