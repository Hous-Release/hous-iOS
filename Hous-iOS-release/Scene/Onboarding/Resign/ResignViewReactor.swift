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
    case setIsCheckButtonSelected(Bool?)
    case setIsResignButtonActivated(Bool?)
    case setIsResignButtonClicked(Bool?)
    case setResignReason(String?)
    case setDetailReason(String?)
    case setIsTextViewEmpty(Bool?)
    case setNumOfText(String?)
    case setIsErrorLabelShow(Bool?)
  }

  struct State {
    var isCheckButtonSelected: Bool? = false
    var isResignButtonActivated: Bool? = false
    @Pulse
    var isResignButtonClicked: Bool?
    var resignReason: String?
    var detailReason: String?
    var isTextViewEmpty: Bool? = true
    var numOfText: String?
    var isErrorLabelShow: Bool? = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:
      guard let isCheckButtonSelected = currentState.isCheckButtonSelected,
            let isOverLimit = currentState.isErrorLabelShow else {
        return .empty()
      }
      return .concat([
        .just(Mutation.setIsCheckButtonSelected(!isCheckButtonSelected)),
        mutationOfActivateResignButton(isOverLimit, !isCheckButtonSelected)
      ])
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

    case let .setIsCheckButtonSelected(flag):
      newState.isCheckButtonSelected = flag
    case let .setIsResignButtonActivated(flag):
      newState.isResignButtonActivated = flag
    case let .setIsResignButtonClicked(flag):
      newState.isResignButtonClicked = flag
    case let .setResignReason(reason):
      newState.resignReason = reason
    case let .setDetailReason(reason):
      newState.detailReason = reason
    case let .setIsTextViewEmpty(flag):
      newState.isTextViewEmpty = flag
    case let .setNumOfText(numString):
      newState.numOfText = numString
    case let .setIsErrorLabelShow(flag):
      newState.isErrorLabelShow = flag
    }

    return newState
  }
}

extension ResignViewReactor {
  private func mutationOfDetailReason(_ text: String?) -> Observable<Mutation> {

    guard let text = text,
          let isCheckButtonSelected = currentState.isCheckButtonSelected else {
      return .empty()

    }

    var textNumString = "\(text.count)/200"
    if text == "의견 남기기" {
      textNumString = "0/200"
    }
    let isOverLimit = text.count > 200

    return .concat([
      .just(Mutation.setDetailReason(text)),
      .just(Mutation.setNumOfText(textNumString)),
      .just(Mutation.setIsErrorLabelShow(isOverLimit)),
      mutationOfActivateResignButton(isOverLimit, isCheckButtonSelected)
    ])
  }

  private func mutationOfActivateResignButton(_ isOverLimit: Bool, _ isCheckButtonSelected: Bool) -> Observable<Mutation> {

    let isResignButtonActivate = !isOverLimit && isCheckButtonSelected
    return .concat([
      .just(Mutation.setIsResignButtonActivated(isResignButtonActivate))
    ])
  }
}
