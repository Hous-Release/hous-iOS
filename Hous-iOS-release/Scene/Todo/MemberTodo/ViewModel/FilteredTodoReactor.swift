//
//  FilteredTodoReactor.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/20.
//

import Foundation
import Network
import ReactorKit

final class FilteredTodoReactor: Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }


  enum Action {
    case viewWillAppear
    case didTapAdd
  }

  enum Mutation {
    case setTransfer
  }

  struct State {
    var homies: [UpdateTodoHomieModel] = []
    @Pulse
    var isTransfer: Void = ()
  }

  let initialState: State = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .empty()
    case .didTapAdd:
      return .just(.setTransfer)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.todoRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      default:
        return .empty()
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }

}
