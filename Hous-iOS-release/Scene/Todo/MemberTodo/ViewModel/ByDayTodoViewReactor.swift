//
//  ByDayTodoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import Foundation

import ReactorKit
import Network
import BottomSheetKit

final class ByDayTodoViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case fetch
    case didTapDaysOfWeekCell(Int)
    case didTapTodo(Int)
    case didTapDelete(Int)
    case initial
  }

  enum Mutation {

    case setIsLoadingHidden(Bool?)

    case setSelectedDayIndexPathRow(Int?)
    case setCountTodoSection(MyOurTodoSection.Model)
    case setMyTodosByDaySection(MyOurTodoSection.Model)
    case setMyTodosEmptySection(MyOurTodoSection.Model)
    case setOurTodosByDaySection(MyOurTodoSection.Model)
    case setOurTodosEmptySection(MyOurTodoSection.Model)

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
    var selectedDayIndexPathRow: Int?
    var countTodoSection = MyOurTodoSection.Model(model: .countTodo, items: [])
    var myTodosByDaySection = MyOurTodoSection.Model(
      model: .myTodo(num: 0),
      items: [])
    var myTodosEmptySection = MyOurTodoSection.Model(model: .myTodoEmpty, items: [])
    var ourTodosByDaySection = MyOurTodoSection.Model(
      model: .ourTodo(num: 0),
      items: [])
    var ourTodosEmptySection = MyOurTodoSection.Model(model: .ourTodoEmpty, items: [])

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

      var currentRow: Int = 0
      if currentState.selectedDayIndexPathRow == nil {
        currentRow = calTodayToIndex()
      } else {
        currentRow = currentState.selectedDayIndexPathRow ?? 0
      }

      provider.byDayRepository.fetchTodo(currentRow)
      return .concat([
        .just(.setIsLoadingHidden(false)),
        .just(Mutation.setSelectedDayIndexPathRow(currentRow))
      ])

    case let .didTapDaysOfWeekCell(row):
      provider.byDayRepository.selectDaysOfWeek(row)
      return .just(Mutation.setSelectedDayIndexPathRow(row))

    case let .didTapTodo(id):

      provider.byDayRepository.fetchTodoSummary(id)
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

    case let .setSelectedDayIndexPathRow(row):
      newState.selectedDayIndexPathRow = row

    case let .setCountTodoSection(cnt):
      newState.countTodoSection = cnt

    case let .setMyTodosByDaySection(myTodo):
      newState.myTodosByDaySection = myTodo

    case let .setMyTodosEmptySection(empty):
      newState.myTodosEmptySection = empty

    case let .setOurTodosByDaySection(ourTodo):
      newState.ourTodosByDaySection = ourTodo

    case let .setOurTodosEmptySection(empty):
      newState.ourTodosEmptySection = empty

    case let .setSelectedTodoId(id):
      newState.selectedTodoId = id

    case let .setSelectedTodoSummary(info):
      newState.selectedTodoSummary = info

    case let .setIsDeleteSuccess(flag):
      newState.isDeleteSuccess = flag

    case let .setError(error):
      newState.error = error
    case .setInitial:

      let currentSelectedDayIndexPathRow = currentState.selectedDayIndexPathRow
      newState = initialState
      newState.selectedDayIndexPathRow = currentSelectedDayIndexPathRow
    }
    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let byDayServiceMutation = provider.byDayRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {

      case let .isLoadingHidden(flag):
        return .just(.setIsLoadingHidden(flag))

      case let .countTodoSection(cnt):
        return .just(.setCountTodoSection(cnt))
      case let .myTodosByDaySection(myTodo):
        return .just(.setMyTodosByDaySection(myTodo))
      case let .myTodosEmptySection(empty):
        return .just(.setMyTodosEmptySection(empty))
      case let .ourTodosByDaySection(ourTodo):
        return .just(.setOurTodosByDaySection(ourTodo))
      case let .ourTodosEmptySection(empty):
        return .just(.setOurTodosEmptySection(empty))
      case let .todoSummary(info):
        return .just(.setSelectedTodoSummary(info))
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      case .initial:
        return.just(.setInitial)
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
          let currentRow = self.currentState.selectedDayIndexPathRow ?? 0
          self.provider.byDayRepository.fetchTodo(currentRow)
        }
        return .just(.setIsDeleteSuccess(isDeleted))

      default:
        return .empty()
      }
    }

    return .merge(
      mutation,
      byDayServiceMutation,
      bottomSheetServiceMutation
    )
  }
}

extension ByDayTodoViewReactor {
  private func calTodayToIndex() -> Int {
    let cal = Calendar(identifier: .gregorian)
    let now = Date()
    let comps = cal.dateComponents([.weekday], from: now)
    guard let weekday = comps.weekday else { return 0 }
    switch weekday {
    case 1:
      return 6
    default:
      return weekday - 2
    }
  }
}
