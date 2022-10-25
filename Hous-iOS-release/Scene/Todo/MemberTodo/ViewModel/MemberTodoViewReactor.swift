//
//  MemberTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import ReactorKit

//final class MemberTodoViewReactor: ReactorKit.Reactor {
//  enum Action {
//    case fetch
//  }
//
//  enum Mutation {
//    case setMemberSection
//    case setTodoSection
//  }
//
//  struct State {
//    var myTodosSection = TodoMainSection.Model(
//      model: .myTodo(num: 0),
//      items: []
//    )
//    var ourTodosSection = TodoMainSection.Model(
//      model: .ourTodo(num: 0),
//      items: []
//    )
//    var error: String? = nil
//  }
//
//  let initialState = State()
//
//  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//    case .fetch:
//      return .empty()
//    }
//  }
//
//  func reduce(state: State, mutation: Mutation) -> State {
//
//    var newState = state
//
//    switch mutation {
//    case .setMemberSection:
//      <#code#>
//    case .setTodoSection:
//      <#code#>
//    }
//    return newState
//  }
//}
