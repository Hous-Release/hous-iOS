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
    case didTapDaysOfWeekCell(Int)
  }

  enum Mutation {
    case setCountTodoSection(ByDayTodoSection.Model)
    case setMyTodosByDaySection(ByDayTodoSection.Model)
    case setMyTodosEmptySection(ByDayTodoSection.Model)
    case setOurTodosByDaySection(ByDayTodoSection.Model)
    case setOurTodosEmptySection(ByDayTodoSection.Model)
    case setError(String?)
    case setInitial
  }

  struct State {
    var countTodoSection = ByDayTodoSection.Model(model: .countTodo, items: [])
    var myTodosByDaySection = ByDayTodoSection.Model(
      model: .myTodo(num: 0),
      items: [])
    var myTodosEmptySection = ByDayTodoSection.Model(model: .myTodoEmpty, items: [])
    var ourTodosByDaySection = ByDayTodoSection.Model(
      model: .ourTodo(num: 0),
      items: [])
    var ourTodosEmptySection = ByDayTodoSection.Model(model: .ourTodoEmpty, items: [])
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      provider.byDayRepository.fetchTodo()
      return .empty()
    case let .didTapDaysOfWeekCell(row):
      provider.byDayRepository.selectDaysOfWeek(row)
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setCountTodoSection(cnt):
      newState.countTodoSection = cnt
    case let .setMyTodosByDaySection(myTodo):
      newState.myTodosByDaySection = myTodo
    case let .setMyTodosEmptySection(empty):
      newState.myTodosEmptySection = empty
    case let .setOurTodosByDaySection(ourTodo):
      newState.ourTodosByDaySection = ourTodo
    case let .setOurTodosEmptySection(empty):
      newState.ourTodosEmptySection = empty
    case let .setError(error):
      newState.error = error
    case .setInitial:
      newState = initialState
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.byDayRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .countTodoSection(cnt):
        print("countTodoSection 🌝🌝🌝🌝🌝\(cnt)")
        return .just(.setCountTodoSection(cnt))
      case let .myTodosByDaySection(myTodo):
        print("myTodosByDaySection 🌝🌝🌝🌝🌝\(myTodo)")
        return .just(.setMyTodosByDaySection(myTodo))
      case let .myTodosEmptySection(empty):
        print("myTodosEmptySection 🌝🌝🌝🌝🌝\(empty)")
        return .just(.setMyTodosEmptySection(empty))
      case let .ourTodosByDaySection(ourTodo):
        print("ourTodosByDaySection 🌝🌝🌝🌝🌝\(ourTodo)")
        return .just(.setOurTodosByDaySection(ourTodo))
      case let .ourTodosEmptySection(empty):
        print("ourTodosEmptySection 🌝🌝🌝🌝🌝\(empty)")
        return .just(.setOurTodosEmptySection(empty))
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      case .initial:
        return.just(.setInitial)
      }
    }

    return .merge(mutation, serviceMutation)
  }
}
