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
    case updateHomie([UpdateTodoHomieModel])
  }

  public enum Mutation {
    case setNotification(Bool)
    case setTodo(String?)
    case setHomies([UpdateTodoHomieModel])
    case setIndividual(IndexPath)
  }

  public struct State {
    var id: Int? = nil
    var isModifying: Bool = false
    var isPushNotification: Bool = false
    var todo: String? = nil
    var todoHomies: [UpdateTodoHomieModel]
    @Pulse
    var didTappedIndividual: IndexPath? = nil
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      if initialState.isModifying {
        provider.todoRepository.fetchModifyingTodo(initialState.id ?? -1)
      }

      else {
        return Observable.concat([
          .just(.setTodo(initialState.todo)),
          .just(.setHomies(initialState.todoHomies))
        ])
      }

      return .empty()

    case .enterTodo:
      return .empty()
    case .didTapHomie(let indexPath):
      return .just(.setIndividual(indexPath))
    case .didTapDays:
      return .empty()
    case .didTapUpdate:
      return .empty()

    case .updateHomie(let homies):
      return .just(.setHomies(homies))
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

    case .setIndividual(let indexPath):
      newState.didTappedIndividual = indexPath
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
