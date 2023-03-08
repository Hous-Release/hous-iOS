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
    case checkStatus(Bool)
  }

  enum Mutation {
    case setCheckStatus(Bool)
    case setError(String?)
  }

  struct State {
    var isChecked: Bool = true
    var error: String?
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .check(todoId, isChecked):
      let newCheckStatus = !isChecked
      var errObservable: Observable<Mutation> = .empty()
      NetworkService.shared.mainTodoRepository.checkTodo(todoId, newCheckStatus) { res, _ in
        guard let res = res else { return }

        guard res.success else {
          let errorModel = HouseErrorModel(
            success: res.success,
            status: res.status,
            message: res.message)
          errObservable = .just(Mutation.setError(errorModel.message))
          return
        }

        if res.success {
          self.action.onNext(.checkStatus(newCheckStatus))
        }
      }
      return errObservable

    case let .checkStatus(status):
      return .just(.setCheckStatus(status))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setCheckStatus(isChecked):
      newState.isChecked = isChecked
    case let .setError(err):
      newState.error = err
    }
    return newState
  }
}
