//
//  PagingViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/23.
//

import UIKit
import RxCocoa
import ReactorKit

final class PagingViewReactor: Reactor {

  enum Action {
    case viewWillAppear
    case skipDidTap
    case nextDidTap
    case didEndScroll(Int)
  }

  enum Mutation {
    case setPagingContents([PagingContent])
    case setSkip
    case setNext
    case setNextHidden(Int)
  }

  struct State {
    var pagingContents: [PagingContent] = []
    var skip: Bool = false
    var next: Bool = false
    var isNextButtonHidden: Bool = true
  }

  let initialState = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .just(Mutation.setPagingContents(PagingContent.sampleData))
    case .skipDidTap:
      return .just(Mutation.setSkip)
    case .nextDidTap:
      return .just(Mutation.setNext)
    case let .didEndScroll(currentPage):
      return .just(Mutation.setNextHidden(currentPage))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {
    case let .setPagingContents(content):
      newState.pagingContents = content
    case .setSkip:
      newState.skip = !currentState.skip
      newState.isNextButtonHidden = false
    case .setNext:
      newState.next = !currentState.next
    case let .setNextHidden(currentPage):
      let state = currentPage == 3 ? false : true
      newState.isNextButtonHidden = state
    }
    return newState
  }
}
