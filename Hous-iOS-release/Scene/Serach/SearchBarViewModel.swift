//
//  SearchBarViewModel.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit
import Combine
import Network
import BottomSheetKit

final class SearchBarViewModel {

  private var subscriptions = Set<AnyCancellable>()
  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
    bindRepository()
  }

  // MARK: - Input
  struct Input {
    let fetch: AnyPublisher<SearchType, Never>
    // let didTapFilterTodo: AnyPublisher<([String]?, [Int]?), Never>
    let searchQuery: AnyPublisher<String?, Never>
    // let didTapCell: AnyPublisher<(Int, SearchType), Never>
    let didTapFloatingBtn: AnyPublisher<SearchType, Never>
  }

  // MARK: - Output
  @Published private(set) var searchedList: [SearchModel]?
  @Published private(set) var filteredTodoCount: Int?

  @Published private(set) var selectedTodo: TodoModel?
  // @Published private(set) var selectedRule: RuleModel?

  @Published private(set) var floatingBtnTapped: SearchType?

  // MARK: - Input -> Output
  func transform(input: Input) {
    input.fetch
      .sink { [unowned self] type in
        if type == .todo {
          self.provider.searchRepository.fetchFilteredTodo(with: nil, of: nil)
        }
      }
      .store(in: &subscriptions)

    input.searchQuery
      .sink { [unowned self] query in
        let queried = getQueriedList(
          of: self.searchedList,
          with: query
        )
        self.searchedList = queried
      }
      .store(in: &subscriptions)

    input.didTapFloatingBtn
      .sink { [unowned self] type in
        self.floatingBtnTapped = type
      }
      .store(in: &subscriptions)
  }
}

extension SearchBarViewModel {

  private func bindRepository() {
    provider.searchRepository.event
      .sink { _ in
        // receivecompletion handling 찾아보기
      } receiveValue: { [weak self] value in
        guard let self = self else { return }
        switch value {
        case let .searchedList(list):
          self.searchedList = list
        case let .filteredTodoCount(count):
          self.filteredTodoCount = count
        case let .selectedTodo(detail):
          self.selectedTodo = detail
        case let .sendError(err):
          print(err?.message ?? "")
        }
      }
      .store(in: &subscriptions)
  }
}

extension SearchBarViewModel {

  private func getQueriedList(
    of list: [SearchModel]?,
    with query: String? = nil,
    limit: Int? = nil) -> [SearchModel]? {
      guard let list = list else { return [] }
      let queried = list.filter { $0.contains(query) }
      if let limit {
          return Array(queried.prefix(through: limit))
      }
      return queried
  }
}
