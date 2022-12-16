//
//  EnterInfoViewReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import Foundation

import ReactorKit
import UserInformation
import Network

final class EnterInfoViewReactor: Reactor {

  private let provider: ServiceProviderType
  private let type: SignInType?
  private let token: String?

  init(provider: ServiceProviderType, signinType: SignInType, oAuthToken: String) {
    self.provider = provider
    self.type = signinType
    self.token = oAuthToken
  }

  enum Action {
    //case viewWillAppear
    case enterNickname(String)
    case enterBirthday(Date?)
    case checkBirthdayPublic(Bool)
    case tapNext
  }

  enum Mutation {
    //case setSigninType(SignInType?)
    //case setOAuthToken(String?)
    case setNickname(String)
    case setBirthday(String)
    case setIsNextButtonEnable(Bool)
    case setIsBirthdayPublic(Bool?)
    case setNextFlag(Bool?)
    case setError(String?)
  }

  struct State {
    //var signinType: SignInType?
    //var oAuthToken: String?
    var nickname: String?
    var birthday: String?
    var isBirthdayPublic: Bool? = true
    var isNextButtonEnable: Bool = false
    var nextFlag: Bool?

    var error: String? = nil
  }

  let initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {

    switch action {
    case let .enterNickname(nickname):
      let birthday = currentState.birthday ?? ""
      return .concat([
        limitMaxLength(of: nickname),
        validateNextButton(nickname, birthday)
      ])

    case let .enterBirthday(birthday):
      let nickname = currentState.nickname ?? ""
      return .concat([
        formatToString(of: birthday),
        validateNextButton(nickname, toString(birthday))
      ])

    case let .checkBirthdayPublic(flag):
      return .just(Mutation.setIsBirthdayPublic(!flag))

    case .tapNext:
      guard let birthday = currentState.birthday,
            let nickname = currentState.nickname,
            let isPublic = currentState.isBirthdayPublic,
            let type = self.type,
            let token = self.token
      else { return .empty() }

      let signupRequestDTO = AuthDTO.Request.SignupRequestDTO(
        birthday: birthday.replacingOccurrences(of: " / ", with: "-"),
        fcmToken: Keychain.shared.getFCMToken() ?? "",
        isPublic: isPublic,
        nickname: nickname,
        socialType: type.description,
        token: token
      )
      signup(signupRequestDTO)
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {

    var newState = state

    switch mutation {

    case let .setNickname(nickname):
      newState.nickname = nickname

    case let .setBirthday(birthday):
      newState.birthday = birthday

    case let .setIsNextButtonEnable(flag):
      newState.isNextButtonEnable = flag

    case let .setIsBirthdayPublic(flag):
      newState.isBirthdayPublic = flag

    case let .setNextFlag(flag):
      newState.nextFlag = flag

    case let .setError(error):
      newState.error = error
    }

    return newState
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

    let serviceMutation = provider.authRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .isJoiningRoom(_):
        return .empty()

      case .updateAccessToken(let accessToken):
        Keychain.shared.setAccessToken(accessToken: accessToken)
        return .just(.setNextFlag(true))

      case .updateRefreshToken(let refreshToken):
        Keychain.shared.setRefreshToken(refreshToken: refreshToken)
        return .empty()

      case .sendError(let errorModel):
        guard
          let errorModel = errorModel else { return .empty() }

        return .just(.setError(errorModel.message))
      }
    }
    return Observable.merge(mutation, serviceMutation)
  }
}

extension EnterInfoViewReactor {

  private func limitMaxLength(of nickname: String) -> Observable<Mutation> {

    let limitedText = nickname.prefix(3)
    return .just(.setNickname(String(limitedText)))
  }

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
    dateFormatter.dateFormat = "YYYY / MM / dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.string(from: birthday)
  }
}

extension EnterInfoViewReactor {
  private func signup(_ dto: AuthDTO.Request.SignupRequestDTO) {
    provider.authRepository.signup(dto)
  }
}
