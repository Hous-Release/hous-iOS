//
//  MyTodoCollectionViewCellReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/17.
//

import Foundation

import RxSwift
import ReactorKit
import Network

final class MyTodoCollectionViewCellReactor: Reactor {

  enum Action {
    case check(Int, Bool)
  }

  enum Mutation {
    case setCheckStatus(Bool)
    case setError(String?)
  }

  struct State {
    var isChecked: Bool = true
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .check(todoId, isChecked):
      var observable: Observable<Mutation> = .empty()
      NetworkService.shared.mainTodoRepository.checkTodo(todoId, !isChecked) { res, err in
        guard (res?.data) != nil else {
          let errorModel = HouseErrorModel(
            success: res?.success ?? false,
            status: res?.status ?? -1,
            message: res?.message ?? "")
          observable = .just(Mutation.setError(errorModel.message))
          return
        }
      }
      return .concat([.just(Mutation.setCheckStatus(isChecked)), observable])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setCheckStatus(isChecked):
      newState.isChecked = !isChecked
    case let .setError(err):
      newState.error = err
    }
    return newState
  }
}
