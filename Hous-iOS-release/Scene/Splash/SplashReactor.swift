//
//  SplashReactor.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/30.
//

import RxCocoa
import RxSwift
import ReactorKit
import UserInformation


final class SplashReactor: Reactor {

  let initialState: State = State()
  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  enum Action {
    case viewWillAppear

  }

  enum Mutation {
    case setIsJoiningRoom(Bool)
    case setIsOnboardingFlow(Bool)
    case setIsLoginFlow(Bool)
    case setShwoAlertByServerError(String?)
  }

  struct State {
    var isJoiningRoom: Bool? = nil
    var isOnboardingFlow: Bool? = nil
    var isLoginFlow: Bool? = nil
    var shwoAlertByServerErrorMessage: String? = nil
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .concat([
        refresh()
      ])

    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {

    case .setIsJoiningRoom(let isJoiningRoom):
      newState.isJoiningRoom = isJoiningRoom

    case .setIsOnboardingFlow(let isOnboardingFlow):
      newState.isOnboardingFlow = isOnboardingFlow

    case .setIsLoginFlow(let isLoginFlow):
      newState.isLoginFlow = isLoginFlow

    case .setShwoAlertByServerError(let errorMessage):
      newState.shwoAlertByServerErrorMessage = errorMessage
    }

    return newState
  }


}

extension SplashReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let serviceMutation = provider.authRepository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .isJoiningRoom(let isJoiningRoom):
        return .just(.setIsJoiningRoom(isJoiningRoom))

      case .updateAccessToken(let accessToken):
        Keychain.shared.setAccessToken(accessToken: accessToken)
        return .empty()

      case .updateRefreshToken(let refreshToken):
        Keychain.shared.setRefreshToken(refreshToken: refreshToken)
        return .empty()

      case .sendError(let errorModel):

        guard
          let errorModel = errorModel,
          let status = errorModel.status
        else {
          return .empty()
        }

        if status == 400 {

          guard
            UserInformation.shared.isInitialUser != nil else {
            return .just(.setIsOnboardingFlow(true))
          }

          return .just(.setIsLoginFlow(true))
        }

        if status == 401 || status == 404 {
          return .just(.setIsLoginFlow(true))
        }

        else {
          return .just(.setShwoAlertByServerError(errorModel.message))
        }

      }
    }

    return Observable.merge(mutation, serviceMutation)
  }
}

extension SplashReactor {
  private func refresh() -> Observable<Mutation> {
    let accessToken = Keychain.shared.getAccessToken() ?? "eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjozLCJleHAiOjE2OTc5NjM0ODh9.yG1Jc3FngP7zzJtj_1v4fw0PwrAhu8ovS1rMo7ob_uzbrqgDoYZXKVIpuwkWdZ5W0ySlCYgvW--e4e8N2KMLdw"
    let refreshToken = Keychain.shared.getRefreshToken() ?? ""

    provider.authRepository.refresh(accessToken, refreshToken)

    return .empty()
  }
}
