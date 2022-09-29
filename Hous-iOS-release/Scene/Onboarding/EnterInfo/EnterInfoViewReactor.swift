//
//  EnterInfoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit

final class EnterInfoViewReactor: Reactor {

  enum Action {
    case enterNickname(String)
    case enterBirthday(Date?)
    case checkBirthdayPublic(Bool)
    case tapNext
  }

  enum Mutation {
    case setNickname(String)
    case setBirthday(String)
    case setIsNextButtonEnable(Bool)
    case setIsBirthdayPublic(Bool)
    case setNextResult
  }

  struct State {
    var nickname: String = ""
    var birthday: String = ""
    var isBirthdayPublic: Bool = false
    var isNextButtonEnable: Bool = false
    var next: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case let .enterNickname(nickname):
      return .concat([
        .just(Mutation.setNickname(nickname)),
        self.validateNextButton(nickname, currentState.birthday)
      ])

    case let .enterBirthday(birthday):
      return .concat([
        self.formatToString(of: birthday),
        self.validateNextButton(currentState.nickname, toString(birthday))
      ])

    case let .checkBirthdayPublic(flag):
      return Observable.just(Mutation.setIsBirthdayPublic(!flag))

    case .tapNext:
      return Observable.just(Mutation.setNextResult)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state
    newState.next = false

    switch mutation {

    case let .setNickname(nickname):
      newState.nickname = nickname

    case let .setBirthday(birthday):
      newState.birthday = birthday

    case let .setIsNextButtonEnable(flag):
      newState.isNextButtonEnable = flag

    case let .setIsBirthdayPublic(flag):
      newState.isBirthdayPublic = flag

    case .setNextResult:
      newState.next = !currentState.next
    }

    return newState
  }
}

extension EnterInfoViewReactor {

  private func validateNextButton(_ nickname: String, _ birthday: String) -> Observable<Mutation> {
    let validation = nickname.count > 0 && birthday != ""
    return .just(Mutation.setIsNextButtonEnable(validation))
  }

  private func formatToString(of birthday: Date?) -> Observable<Mutation> {
    return .just(Mutation.setBirthday(toString(birthday)))
  }

  private func toString(_ birthday: Date?) -> String {
    guard let birthday = birthday else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY/MM/dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.string(from: birthday)
  }
}
