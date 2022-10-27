//
//  MemberTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

import ReactorKit
import Differentiator

final class MemberTodoViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
  }

  enum Mutation {
    case setMembersSection(MemberSection.Model?)
    case setTodosSection(TodoByMemSection.Model?)
  }

  struct State {
    var membersSection = MemberSection.Model(
      model: .members(num: 0),
      items: []
    )
    var todosSection = TodoByMemSection.Model(
      model: .todos(num: 0),
      items: []
    )
    //var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      provider.memberRepository.fetchMember()
      return .empty() 
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setMembersSection(data):
      newState.membersSection = data ?? MemberSection.Model(
        model: .members(num: 0),
        items: [])
    case let .setTodosSection(data):
      newState.todosSection = data ?? TodoByMemSection.Model(
        model: .todos(num: 0),
        items: []
      )
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.memberRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .membersSection(data):
        return .just(.setMembersSection(data))
      case let .todosSection(data):
        return .just(.setTodosSection(data))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}
