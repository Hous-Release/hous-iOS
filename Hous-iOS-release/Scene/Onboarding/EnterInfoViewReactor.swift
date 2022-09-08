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
    //(서버통신 결과 - 닉네입 중복 팝업 혹은 온보딩 뷰 진입) 추후 수정
    case setNextResult(Bool)
  }

  struct State {
    var nickname: String = ""
    var birthday: String = ""
    var isBirthdayPublic: Bool = false
    var isNextButtonEnable: Bool = false
    var serverResult: Bool = false
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case let .enterNickname(nickname):
      return .concat([
        .just(Mutation.setNickname(nickname)),
        self.validateNextButton(nickname, currentState.birthday)
          .map { Mutation.setIsNextButtonEnable($0)}
      ])

    case let .enterBirthday(birthday):
      return Observable.concat([
        self.formatToString(of: birthday)
          .map { Mutation.setBirthday($0)}
        ,
        self.validateNextButton(currentState.nickname, currentState.birthday)
          .map { Mutation.setIsNextButtonEnable($0)}
      ])

    case let .checkBirthdayPublic(flag):
      return Observable.just(Mutation.setIsBirthdayPublic(!flag))

    case .tapNext:
      return Observable.just(Mutation.setNextResult(true))
    }
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation.debug("mutation")
  }

  func reduce(state: State, mutation: Mutation) -> State {
    switch mutation {

    case let .setNickname(nickname):
      var newState = state
      newState.nickname = nickname
      return newState

    case let .setBirthday(birthday):
      var newState = state
      newState.birthday = birthday
      return newState

    case let .setIsNextButtonEnable(flag):
      var newState = state
      newState.isNextButtonEnable = flag
      return newState

    case let .setIsBirthdayPublic(flag):
      var newState = state
      newState.isBirthdayPublic = flag
      return newState

    case let .setNextResult(flag):
      var newState = state
      newState.serverResult = flag
      return newState
    }
  }

  private func validateNextButton(_ nickname: String, _ birthday: String) -> Observable<Bool> {
    return nickname.count > 2 && birthday != "" ? .just(true) : .just(false)
  }

  private func formatToString(of birthday: Date?) -> Observable<String> {
    guard let birthday = birthday else { return .empty() }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY/MM/dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")

    return .just(dateFormatter.string(from: birthday))
  }
}
