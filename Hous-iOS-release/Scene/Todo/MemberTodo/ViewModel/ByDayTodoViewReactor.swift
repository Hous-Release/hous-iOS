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
    case setOurTodosByDaySection(ByDayTodoSection.Model)
    case setError(String?)
  }

  struct State {
    var countTodoSection = ByDayTodoSection.Model(model: .countTodo, items: [])
    var myTodosByDaySection = ByDayTodoSection.Model(
      model: .myTodo(num: 0),
      items: [])
    var ourTodosByDaySection = ByDayTodoSection.Model(
      model: .ourTodo(num: 0),
      items: [])
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
    case let .setOurTodosByDaySection(ourTodo):
      newState.ourTodosByDaySection = ourTodo
    case let .setError(error):
      newState.error = error
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.byDayRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .countTodoSection(cnt):
        return .just(.setCountTodoSection(cnt))
      case let .myTodosByDaySection(myTodo):
        return .just(.setMyTodosByDaySection(myTodo))
      case let .ourTodosByDaySection(ourTodo):
        return .just(.setOurTodosByDaySection(ourTodo))
      case let .sendError(errorModel):
        guard let errormodel = errorModel else { return .empty() }
        return .just(.setError(errorModel?.message))
      }
    }

    return .merge(mutation, serviceMutation)
  }
}
