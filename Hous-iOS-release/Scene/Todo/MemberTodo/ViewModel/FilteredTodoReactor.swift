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
    case setHomies([UpdateTodoHomieModel])
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
      provider.todoRepository.fetchHomie()
      return .empty()

    case .didTapAdd:
      return .just(.setTransfer)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setHomies(let homies):
      newState.homies = homies

    case .setTransfer:
      newState.isTransfer = Void()
    }

    return newStatec
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.todoRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .getMembers(let homies):

        return .just(.setHomies(homies))
      default:
        return .empty()
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }

}
