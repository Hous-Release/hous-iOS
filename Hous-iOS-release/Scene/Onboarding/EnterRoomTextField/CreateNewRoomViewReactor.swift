//
//  CreateNewRoomViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit
import RxCocoa
import ReactorKit

final class CreateNewRoomViewReactor: Reactor {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case enterRoomName(String?)
    case tapCreateRoom(String?)
    case initial
  }

  enum Mutation {
    case setRoomName(String?)
    case setRoomNameCount(String?)
    case setIsButtonEnable(Bool)
    case setIsErrorMessageHidden(Bool?)
    case setErrorMessage(String?)
    case setRoomCode(String?)
    case setViewTransition(Bool?)
    case setError(String?)
    case setInitial
  }

  struct State {
    var roomName: String?
    var roomNameCount: String?
    var isButtonEnable: Bool = false
    var isErrorMessageHidden: Bool?
    var errorMessage: String?
    var roomCode: String?
    @Pulse var viewTransition: Bool?
    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .enterRoomName(roomName):
      guard let roomName = roomName else { return .empty() }
      return .concat([
        concatObservable(of: roomName),
        limitCount(of: roomName)
      ])

    case let .tapCreateRoom(roomName):
      guard let roomName = roomName else { return .empty() }
      provider.enterRoomRepository.enterNewRoom(roomName)
      return .empty()

    case .initial:
      return .just(.setInitial)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    switch mutation {
    case let .setRoomName(name):
      newState.roomName = name
    case let .setRoomNameCount(count):
      newState.roomNameCount = count
    case let .setIsButtonEnable(status):
      newState.isButtonEnable = status
    case let .setIsErrorMessageHidden(flag):
      newState.isErrorMessageHidden = flag
    case let .setErrorMessage(message):
      newState.errorMessage = message
    case let .setRoomCode(code):
      newState.roomCode = code
    case let .setViewTransition(status):
      newState.viewTransition = status
    case let .setError(error):
      newState.error = error
    case .setInitial:
      newState = initialState
    }
    return newState
  }
}

extension CreateNewRoomViewReactor {
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.enterRoomRepository.event.flatMap { event ->
      Observable<Mutation> in
      switch event {
      case .roomHostNickname:
        return .empty()
      case let .roomCode(code):
        return .just(.setRoomCode(code))
      case .roomId:
        return .empty()
      case let .sendError(errorModel):
        guard
          let errorModel = errorModel,
          let statusCode = errorModel.status
        else {
          return .empty()
        }
        if statusCode == 400 || statusCode == 409 {
          return .concat([
            .just(.setIsErrorMessageHidden(false)),
            .just(.setErrorMessage(errorModel.message))
          ])
        }
        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}

extension CreateNewRoomViewReactor {
  private func concatObservable(of roomName: String) -> Observable<Mutation> {

    let buttonFlag = roomName.count > 0 && roomName.count <= 8
    var count = roomName.count
    if count > 8 { count = 8 }
    let labelText = "\(String(count)) / 8"

    return .concat([
      .just(.setRoomName(roomName)),
      .just(.setIsErrorMessageHidden(true)),
      .just(.setIsButtonEnable(buttonFlag)),
      .just(.setRoomNameCount(labelText))
    ])
  }

  private func limitCount(of roomName: String) -> Observable<Mutation> {
    if roomName.count > 8 {
      let message = "방 이름은 8글자 미만으로 설정해주세요"
      return .concat([
        .just(.setIsErrorMessageHidden(false)),
        .just(.setErrorMessage(message))
      ])
    }
    return .empty()
  }
}
