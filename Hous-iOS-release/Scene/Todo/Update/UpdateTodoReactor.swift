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

  }

  public struct State {
    var isModifying: Bool = false
    var isPushNotification: Bool = false
    var todo: String? = nil
    var todoHomies: [UpdateTodoHomieModel] = []
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
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

    return newState
  }

}

public extension UpdateTodoReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let service = provider.todoRepository.event.flatMap { [weak self] event -> Observable<Mutation> in
      switch event {
      default:
        return .empty()
      }
    }
    return Observable.merge(mutation, service)
  }
}
