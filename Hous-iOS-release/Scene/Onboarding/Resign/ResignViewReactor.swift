//
//  ResignViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit
import ReactorKit

class ResignViewReactor: ReactorKit.Reactor {

  enum Action {
    case didTapCheck
    case didTapResign
    case didSelectResignReason(String?)
    case enterDetailReason(String?)
  }

  enum Mutation {
    case setIsResignButtonActivated(Bool)
    case setIsResignButtonClicked(Bool?)
    case setResignReason(String?)
    case setDetailReason(String?)
    case setNumOfText(String?)
  }

  struct State {
    var isResignButtonActivated: Bool = false
    @Pulse
    var isResignButtonClicked: Bool?
    var resignReason: String?
    var detailReason: String?
    var numOfText: String?
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:
      return .just(Mutation.setIsResignButtonActivated(!currentState.isResignButtonActivated))
    case .didTapResign:
      return .empty()
    case let .didSelectResignReason(reason):
      return .just(Mutation.setResignReason(reason))
    case let .enterDetailReason(reason):
      return mutationOfDetailReason(reason)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setIsResignButtonActivated(flag):
      newState.isResignButtonActivated = flag
    case let .setIsResignButtonClicked(flag):
      newState.isResignButtonClicked = flag
    case let .setResignReason(reason):
      newState.resignReason = reason
    case let .setDetailReason(reason):
      newState.detailReason = reason
    case let .setNumOfText(numString):
      newState.numOfText = numString
    }

    return newState
  }
}

extension ResignViewReactor {
  private func mutationOfDetailReason(_ text: String?) -> Observable<Mutation> {

    guard let text = text else { return .empty() }
    let textNumString = "\(text.count)/200"

    return .concat([
      .just(Mutation.setDetailReason(text)),
      .just(Mutation.setNumOfText(textNumString))
    ])
  }
}
