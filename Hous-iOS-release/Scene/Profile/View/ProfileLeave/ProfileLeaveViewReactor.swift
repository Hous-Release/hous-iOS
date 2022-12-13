//
//  ProfileLeaveViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit
import ReactorKit
import Network

class ProfileLeaveViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
    case initial
  }

  enum Mutation {
    case setGuideSection(OnlyMyTodoSection.Model)
    case setCountTodoSection(OnlyMyTodoSection.Model)
    case setMyTodoSection(OnlyMyTodoSection.Model)
    case setMyTodoEmptySection(OnlyMyTodoSection.Model)
    case setInitial
    case setError(String?)
  }

  struct State {
    var guideSection = OnlyMyTodoSection.Model(model: .guide, items: [])
    var countTodoSection = OnlyMyTodoSection.Model(model: .countTodo, items: [])
    var myTodoSection = OnlyMyTodoSection.Model(
      model: .myTodo(num: 0),
      items: [])
    var myTodoEmptySection = OnlyMyTodoSection.Model(
      model: .myTodoEmpty,
      items: [])
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .fetch:
      provider.profileLeaveRepository.fetchOnlyMyTodo()
      return .empty()
    case .initial:
      return .just(.setInitial)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setGuideSection(guide):
      newState.guideSection = guide
    case let .setCountTodoSection(cnt):
      newState.countTodoSection = cnt
    case let .setMyTodoSection(myTodo):
      newState.myTodoSection = myTodo
    case let .setMyTodoEmptySection(empty):
      newState.myTodoEmptySection = empty
    case .setInitial:
      newState = initialState
    case let .setError(error):
      newState.error = error
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let serviceMutation = provider.profileLeaveRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .guideSection(guide):
        return .just(.setGuideSection(guide))
      case let .countTodoSection(cnt):
        return .just(.setCountTodoSection(cnt))
      case let .myTodosByDaySection(myTodo):
        return .just(.setMyTodoSection(myTodo))
      case let .myTodosEmptySection(empty):
        return .just(.setMyTodoEmptySection(empty))

      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      }
    }

    return .merge(mutation, serviceMutation)
  }
}
