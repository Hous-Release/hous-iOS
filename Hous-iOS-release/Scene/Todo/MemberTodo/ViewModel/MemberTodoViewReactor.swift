//
//  MemberTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

import ReactorKit
import Network

final class MemberTodoViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
    case didTapMemberCell(Int)
  }

  enum Mutation {
    case setSelectedMemIndexPathRow(Int?)
    case setMembers(MemberSection.Model?)
    case setSelectedMember([MemberHeaderItem]?)
    case setError(String?)
  }

  struct State {
    @Pulse var selectedMemIndexPathRow: Int?
    var membersSection = MemberSection.Model(
      model: .members(num: 0),
      items: []
    )
    var selectedMember: [MemberHeaderItem]?
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      let currentRow = currentState.selectedMemIndexPathRow ?? 0

      provider.memberRepository.fetchMember(currentRow)
      return .just(Mutation.setSelectedMemIndexPathRow(currentRow))

    case let .didTapMemberCell(row):
      provider.memberRepository.selectMember(row)
      return .just(Mutation.setSelectedMemIndexPathRow(row))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setSelectedMemIndexPathRow(row):
      newState.selectedMemIndexPathRow = row
    case let .setMembers(data):
      newState.membersSection = data ?? MemberSection.Model(
        model: .members(num: 0),
        items: [])
    case let .setSelectedMember(data):
      newState.selectedMember = data
    case let .setError(error):
      newState.error = error
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.memberRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .members(data):
        return .just(.setMembers(data))
      case let .selectedMember(data):
        return .just(.setSelectedMember(data))
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}
