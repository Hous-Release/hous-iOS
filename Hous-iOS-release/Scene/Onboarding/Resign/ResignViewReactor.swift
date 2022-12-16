//
//  ResignViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit
import ReactorKit
import Network

class ResignViewReactor: ReactorKit.Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case didTapCheck
    case didTapResign
    case didSelectResignReason(String?)
    case enterDetailReason(String?)
  }

  enum Mutation {
    case setIsCheckButtonSelected(Bool)
    case setIsResignButtonActivated(Bool?)
    case setIsResignSuccess(Bool?)
    case setResignReason(String?)
    case setDetailReason(String?)
    case setIsTextViewEmpty(Bool?)
    case setNumOfText(String?)
    case setIsErrorLabelShow(Bool)
    case setError(String?)
  }

  struct State {
    var isCheckButtonSelected: Bool = false
    var isResignButtonActivated: Bool? = false
    @Pulse
    var isResignSuccess: Bool?
    var resignReason: String?
    var detailReason: String?
    var isTextViewEmpty: Bool? = true
    var numOfText: String?
    var isErrorLabelShow: Bool = false

    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case .didTapCheck:
      return .concat([
        .just(Mutation.setIsCheckButtonSelected(!currentState.isCheckButtonSelected)),
        mutationOfActivateResignButton(!currentState.isCheckButtonSelected)
      ])

    case .didTapResign:
      guard let comment = currentState.detailReason,
            let feedbackType = currentState.resignReason,
            let serverCode = ResignReasonType(rawValue: feedbackType)?.description else {
        return .empty()
      }

      let dto = UserDTO.Request.DeleteUserRequestDTO(
        comment: comment,
        feedbackType: serverCode
      )

      provider.userRepository.deleteUser(dto)
      return .empty()

    case let .didSelectResignReason(reason):
      return .concat([
        .just(Mutation.setResignReason(reason)),
        mutationOfActivateResignButton(currentState.isCheckButtonSelected)
      ])

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
    case let .setIsResignSuccess(flag):
      newState.isResignSuccess = flag
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
    case let .setError(error):
      newState.error = error
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let serviceMutation = provider.userRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .isResignSuccess(flag):
        return .just(.setIsResignSuccess(flag))

      case let .sendError(errorModel):
        guard
          let errorModel = errorModel else { return .empty() }

        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}

extension ResignViewReactor {
  private func mutationOfDetailReason(_ text: String?) -> Observable<Mutation> {

    guard let text = text else { return .empty() }

    var textNumString = "\(text.count)/200"
    if text == "의견 남기기" {
      textNumString = "0/200"
    }
    let isOverLimit = text.count > 200

    return .concat([
      .just(Mutation.setDetailReason(text)),
      .just(Mutation.setNumOfText(textNumString)),
      .just(Mutation.setIsErrorLabelShow(isOverLimit)),
      mutationOfActivateResignButton(currentState.isCheckButtonSelected)
    ])
  }

  private func mutationOfActivateResignButton(_ isCheckButtonSelected: Bool) -> Observable<Mutation> {

    let isResignButtonActivate =
      !currentState.isErrorLabelShow &&
      isCheckButtonSelected &&
      currentState.resignReason != ""

    return .concat([
      .just(Mutation.setIsResignButtonActivated(isResignButtonActivate))
    ])
  }
}
