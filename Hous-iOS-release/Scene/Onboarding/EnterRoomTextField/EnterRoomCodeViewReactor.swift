//
//  EnterRoomCodeViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit
import RxCocoa
import ReactorKit

final class EnterRoomCodeViewReactor: Reactor {

  /*
   Action
   1. textfield text
   2. enterButton Tap

   State
   1. server + isValidCode - > yes : view transition & no : errorLabel ishidden false
   */

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case enterRoomCode(String?)
    case tapEnterRoom(String?)
    case initial
  }

  enum Mutation {
    case setRoomCode(String?)
    case setIsButtonEnable(Bool)
    case setIsErrorMessageHidden(Bool?)
    case setErrorMessage(String?)
    case setRoomHostNickname(String?)
    case setRoomId(Int?)
    case setViewTransition(Bool?)
    case setError(String?)
    case setInitial
  }

  struct State {
    var roomCode: String?
    var isButtonEnable: Bool = false
    var isErrorMessageHidden: Bool?
    var errorMessage: String?
    var roomHostNickname: String?
    var roomId: Int?
    @Pulse var viewTransition: Bool?
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .enterRoomCode(code):
      guard let code = code else { return .empty() }
      return concatObservable(of: code)

    case let .tapEnterRoom(code):
      guard let code = code else { return .empty() }
      provider.enterRoomRepository.checkExistRoom(code)
      return .empty()

    case .initial:
      return .just(.setInitial)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    switch mutation {
    case let .setRoomCode(code):
      newState.roomCode = code
    case let .setIsButtonEnable(flag):
      newState.isButtonEnable = flag
    case let .setIsErrorMessageHidden(flag):
      newState.isErrorMessageHidden = flag
    case let .setErrorMessage(message):
      newState.errorMessage = message
    case let .setRoomHostNickname(nickname):
      newState.roomHostNickname = nickname
    case let .setRoomId(id):
      newState.roomId = id
    case let .setViewTransition(flag):
      newState.viewTransition = flag
    case let .setError(error):
      newState.error = error
    case .setInitial:
      newState = initialState
    }
    return newState
  }
}

extension EnterRoomCodeViewReactor {
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.enterRoomRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .enterRoomResponse(nickname):
        return .just(.setRoomHostNickname(nickname))
      case let .roomId(id):
        return self.validateRoom(id)
      case let .sendError(errorModel):
        guard let errorModel = errorModel else { return .empty() }
        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}

extension EnterRoomCodeViewReactor {
  private func concatObservable(of roomCode: String) -> Observable<Mutation> {
    return .concat([
      .just(.setRoomCode(roomCode)),
      .just(.setIsErrorMessageHidden(true)),
      .just(.setIsButtonEnable(roomCode.count > 0))
    ])
  }

  private func validateRoom(_ id: Int?) -> Observable<Mutation> {
    if id == nil {
      return .concat([
        .just(.setIsErrorMessageHidden(false)),
        .just(.setErrorMessage("유효하지 않은 방 코드입니다"))
      ])
    } else {
      return .concat([
        .just(.setRoomId(id)),
        .just(.setViewTransition(true))
      ])
    }
  }
}
