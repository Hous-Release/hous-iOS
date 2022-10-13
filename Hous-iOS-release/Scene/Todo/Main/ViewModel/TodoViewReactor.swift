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
  }

  enum Mutation {
    case setDate(String)
    case setDayOfWeek(String)
    case setProgressType(ProgressType)
    case setProgress(Float)
    case setMyTodosSection(TodoMainSection.Model)
    case setOurTodosSection(TodoMainSection.Model)
  }

  struct State {
    var date: String = ""
    var dayOfWeek: String = ""
    var progressType: ProgressType = .none
    var progress: Float = 0
    var myTodosSection = TodoMainSection.Model(
      model: .myTodo(num: 0),
      items: []
    )
    var ourTodosSection = TodoMainSection.Model(
      model: .ourTodo(num: 0),
      items: []
    )
  }

  let initialState = State()

  private let todoRepository: TodoRepository = TodoRepositoryImp()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      todoRepository.fetchTodo()
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setDate(date):
      newState.date = date
    case let .setDayOfWeek(dayOfWeek):
      newState.dayOfWeek = dayOfWeek
    case let .setProgressType(type):
      newState.progressType = type
    case let .setProgress(progress):
      newState.progress = progress
    case let .setMyTodosSection(myTodo):
      newState.myTodosSection = myTodo
    case let .setOurTodosSection(ourTodo):
      newState.ourTodosSection = ourTodo
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = todoRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .date(date):
        return .just(.setDate(date))
      case let .dayOfWeek(dayOfWeek):
        return .just(.setDayOfWeek(dayOfWeek))
      case let .progressType(type):
        return .just(.setProgressType(type))
      case let .progress(progress):
        return .just(.setProgress(progress))
      case let .myTodosSection(myTodo):
        return .just(.setMyTodosSection(myTodo))
      case let .ourTodosSection(ourTodo):
        return .just(.setOurTodosSection(ourTodo))
      }
    }

    return Observable.merge(mutation, serviceMutation)
  }

  //  private func getTodos() -> Observable<MainTodoDTO.Response.MainTodoResponseDTO> {
  //    NetworkService.shared.mainTodoRepository.getTodosData { res, error in
  //      // mutate .... 늘리기... signin 로직 참고하기
  //      guard let data = res, let model = data.data else { return }
  //      return .just(Mutation.setTodoMain(model))
  //    }
  //  }
}
