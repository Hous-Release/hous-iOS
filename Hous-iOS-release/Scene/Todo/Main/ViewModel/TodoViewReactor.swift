//
//  TodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/14.
//

import Foundation
import Network
import ReactorKit

final class TodoViewReactor: Reactor {

  enum Action {
    case fetch
    case didTapViewAll
    case initial
  }

  enum Mutation {
    case setIsLoadingHidden(Bool?)

    case setDate(String)
    case setDayOfWeek(String)
    case setProgressType(ProgressType)
    case setProgress(Float)
    case setIsTodoEmpty(Bool)
    case setMyTodosSection(TodoMainSection.Model)
    case setMyTodosEmptySection(TodoMainSection.Model)
    case setOurTodosSection(TodoMainSection.Model)
    case setOurTodosEmptySection(TodoMainSection.Model)
    case setError(String?)
    case setViewAllFlag(Bool?)
    case setInitial
  }

  struct State {

    @Pulse
    var isLoadingHidden: Bool?

    var date: String = ""
    var dayOfWeek: String = ""
    @Pulse var progressType: ProgressType?
    @Pulse var progress: Float?
    @Pulse var isTodoEmpty: Bool?
    var myTodosSection = TodoMainSection.Model(
      model: .myTodo(num: 0),
      items: [])
    var myTodosEmptySection = TodoMainSection.Model(
      model: .myTodoEmpty,
      items: [])
    var ourTodosSection = TodoMainSection.Model(
      model: .ourTodo(num: 0),
      items: [])
    var ourTodosEmptySection = TodoMainSection.Model(
      model: .ourTodoEmpty,
      items: [])
    var error: String?
    @Pulse var enterViewAllFlag: Bool?
  }

  let initialState = State()

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      self.action.onNext(.initial)
      self.provider.todoRepository.fetchTodo()
      return .just(.setIsLoadingHidden(false))

    case .didTapViewAll:
      return .just(.setViewAllFlag(true))

    case .initial:
      return .just(.setInitial)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setIsLoadingHidden(flag):
      newState.isLoadingHidden = flag

    case let .setDate(date):
      newState.date = date
    case let .setDayOfWeek(dayOfWeek):
      newState.dayOfWeek = dayOfWeek
    case let .setProgressType(type):
      newState.progressType = type
    case let .setProgress(progress):
      newState.progress = progress
    case let .setIsTodoEmpty(flag):
      newState.isTodoEmpty = flag
    case let .setMyTodosSection(myTodo):
      newState.myTodosSection = myTodo
    case let .setMyTodosEmptySection(empty):
      newState.myTodosEmptySection = empty
    case let .setOurTodosSection(ourTodo):
      newState.ourTodosSection = ourTodo
    case let .setOurTodosEmptySection(empty):
      newState.ourTodosEmptySection = empty
    case let .setError(error):
      newState.error = error
    case let .setViewAllFlag(isGoingViewAll):
      newState.enterViewAllFlag = isGoingViewAll

    case .setInitial:
      newState = initialState
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.todoRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .date(date):
        return .just(.setDate(date))
      case let .dayOfWeek(dayOfWeek):
        return .just(.setDayOfWeek(dayOfWeek))
      case let .progressType(type):
        return .just(.setProgressType(type))
      case let .progress(progress):
        return .just(.setProgress(progress))
      case let .isTodoEmpty(flag):
        return .just(.setIsTodoEmpty(flag))
      case let .myTodosSection(myTodo):
        return .just(.setMyTodosSection(myTodo))
      case let .myTodosEmptySection(empty):
        return .just(.setMyTodosEmptySection(empty))
      case let .ourTodosSection(ourTodo):
        return .just(.setOurTodosSection(ourTodo))
      case let .ourTodosEmptySection(empty):
        return .just(.setOurTodosEmptySection(empty))
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))

      case let .isLoadingHidden(flag):
        return .just(.setIsLoadingHidden(flag))

      default:
        return .empty()
      }
    }

    return Observable.merge(mutation, serviceMutation)
  }
}
