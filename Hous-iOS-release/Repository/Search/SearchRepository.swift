//
//  SearchRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/30.
//

import Foundation
import Combine
import Network
import BottomSheetKit

// MARK: - TODOSEARCH

public enum SearchRepositoryEvent {

  case searchedList([SearchModel]?)
  case filteredTodoCount(Int?)
  case selectedTodo(TodoModel?)
  // case selectedRule(RuleModel?)
  case sendError(HouseErrorModel?)
}

public protocol SearchRepository {

  var event: PassthroughSubject<SearchRepositoryEvent, HouseErrorModel> { get }

  /// Runs  search with filtering
  func fetchFilteredTodo(
    with ids: [Int]?,
    of dayOfWeeks: [String]?
  )

  /// func fetchRule()

  /// Fetches details for searchResult with specified id
  func fetchTodoDetail(
    with id: Int
  )

  /// func fetchRuleDetail()
}

public final class SearchRepositoryImp: BaseService, SearchRepository {

  /// PassthroughSubject -> rxSwift 에서의 PublishSubject
  /// AnyCancellable -> rxSwift 에서의 disposeBag 역할
  public var event = PassthroughSubject<SearchRepositoryEvent, HouseErrorModel>()
  private var subscriptions: Set<AnyCancellable> = []

  public func fetchFilteredTodo(
    with ids: [Int]?,
    of dayOfWeeks: [String]?) {

      let dto = MainTodoDTO.Request.getTodosFilteredRequestDTO(
        dayOfWeeks: dayOfWeeks,
        onboardingIds: ids)

      NetworkService.shared.newTodoRepository.getTodoByFilter(dto: dto)
        .sink { [weak self] completion in
          guard let self = self else { return }

          switch completion {
          case .failure(let err):
            let errorModel = HouseErrorModel(
              success: false,
              status: err.responseCode ?? -1,
              message: err.localizedDescription
            )
            self.event.send(.sendError(errorModel))
          case .finished:
            break
          }

        } receiveValue: { [weak self] value in
          guard let self = self else { return }
          guard let searchResult = value.data else { return }

          self.event.send(.filteredTodoCount(searchResult.todosCnt))

          var filteredTodo: [SearchModel] = []
          searchResult.todos.forEach { res in
            filteredTodo.append(
              SearchModel(isNew: res.isNew, id: res.todoId, name: res.todoName)
            )
          }
          self.event.send(.searchedList(filteredTodo))
        }
        .store(in: &subscriptions)

    }

  public func fetchTodoDetail(with id: Int) {

  }

}

// MARK: - RULE SEARCH

final class SearchRuleRepositoryImp {
  // 추후 rule search 뷰에서 search custom view를 넣는 방향으로 리팩토링 시
}
