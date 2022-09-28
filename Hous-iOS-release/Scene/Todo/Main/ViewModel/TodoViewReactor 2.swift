//
//  TodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/14.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit

final class TodoViewReactor: Reactor {

  enum Action {
    case fetch
  }

  enum Mutation {
    case setTodoMain(TodoMainDTO)
  }

  struct State {
    var date: String = ""
    var dayOfWeek: String = ""
    var myTodosSection = TodoMainSection.Model(
      model: .myTodo(num: 0),
      items: []
    )
    var ourTodosSection = TodoMainSection.Model(
      model: .ourTodo(num: 0),
      items: []
    )
    var progress: Int = 0
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      guard let data = MockParser.load(TodoMainDTO.self, from: "TodoMainDTO") else { return .empty() }
      return .just(Mutation.setTodoMain(data))
    }
  }

//  func transform(state: Observable<State>) -> Observable<State> {
//       return state.debug("state")
//  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setTodoMain(data):
      newState.date = data.date
      newState.dayOfWeek = parseDayOfWeek(of: data.dayOfWeek)

      let myTodoItems = data.myTodos.map { TodoMainSection.Item.myTodo(todos: $0)}
      newState.myTodosSection = TodoMainSection.Model(model: .myTodo(num: data.myTodosCnt), items: myTodoItems)
      let ourTodoItems = data.ourTodos.map { TodoMainSection.Item.ourTodo(todos: $0)}
      newState.ourTodosSection = TodoMainSection.Model(model: .ourTodo(num: data.ourTodosCnt), items: ourTodoItems)


      newState.progress = data.progress
    }
    return newState
  }
}

extension TodoViewReactor {
  func parseDayOfWeek(of dayOfWeek: String) -> String {
    return dayOfWeek.prefix(1) + dayOfWeek.dropFirst().lowercased()
  }
}
