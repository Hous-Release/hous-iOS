//
//  MemberTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation

import ReactorKit
import Network
import BottomSheetKit

final class MemberTodoViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
    case didTapMemberCell(Int)
    case didTapTodo(Int)
    case didTapDelete(Int)
    case initial
  }

  enum Mutation {
    case setIsLoadingHidden(Bool?)

    case setSelectedMemIndexPathRow(Int?)
    case setMembers(MemberSection.Model?)
    case setSelectedMember(MemberTodoModel?)

    case setSelectedTodoId(Int?)
    case setSelectedTodoSummary(TodoModel?)

    case setIsDeleteSuccess(Bool?)

    case setError(String?)
    case setInitial
  }

  struct State {

    @Pulse
    var isLoadingHidden: Bool?

    @Pulse
    var selectedMemIndexPathRow: Int?
    var membersSection = MemberSection.Model(
      model: .members(num: 0),
      items: []
    )
    var selectedMember: MemberTodoModel?

    var selectedTodoId: Int?
    @Pulse
    var selectedTodoSummary: TodoModel?

    @Pulse
    var isDeleteSuccess: Bool?

    var error: String?
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:

      let currentRow = currentState.selectedMemIndexPathRow ?? 0
      provider.memberRepository.fetchMember(currentRow)
      return .just(.setIsLoadingHidden(false))

    case let .didTapMemberCell(row):

      provider.memberRepository.selectMember(row)
      return .just(Mutation.setSelectedMemIndexPathRow(row))

    case let .didTapTodo(id):

      provider.todoRepository.fetchTodoSummary(id)
      return .just(.setSelectedTodoId(id))

    case let .didTapDelete(id):

      provider.todoRepository.deleteTodo(id)
      return .concat([
        .just(.setInitial),
        .just(.setIsLoadingHidden(false))
      ])

    case .initial:
      return .just(.setInitial)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setIsLoadingHidden(flag):
      newState.isLoadingHidden = flag

    case let .setSelectedMemIndexPathRow(row):
      newState.selectedMemIndexPathRow = row
    case let .setMembers(data):
      newState.membersSection = data ?? MemberSection.Model(
        model: .members(num: 0),
        items: [])
    case let .setSelectedMember(data):
      newState.selectedMember = data

    case let .setSelectedTodoId(id):
      newState.selectedTodoId = id
    case let .setSelectedTodoSummary(info):
      newState.selectedTodoSummary = info
    case let .setIsDeleteSuccess(flag):
      newState.isDeleteSuccess = flag

    case let .setError(error):
      newState.error = error
    case .setInitial:
      newState = initialState
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let memServiceMutation = provider.memberRepository.event.flatMap { event -> Observable<Mutation> in

      switch event {

      case let .isLoadingHidden(flag):
        return .just(.setIsLoadingHidden(flag))

      case let .members(data):
        return .just(.setMembers(data))
      case let .selectedMember(data):
        return .just(.setSelectedMember(data))
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      }
    }

    let bottomSheetServiceMutation =
    provider.todoRepository.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let self = self else { return .empty() }

      switch event {

      case let .isLoadingHidden(flag):
        return .just(.setIsLoadingHidden(flag))

      case let .todoSummary(info):
        return .just(.setSelectedTodoSummary(info))

      case let .isDeleteSuccess(isDeleted):
        guard let isDeleted = isDeleted else { return .empty() }
        if isDeleted {
          let currentRow = self.currentState.selectedMemIndexPathRow ?? 0
          self.provider.memberRepository.fetchMember(currentRow)
        }
        return .just(.setIsDeleteSuccess(isDeleted))

      default:
        return .empty()
      }
    }

    return Observable.merge(
      mutation,
      memServiceMutation,
      bottomSheetServiceMutation
    )
  }
}
