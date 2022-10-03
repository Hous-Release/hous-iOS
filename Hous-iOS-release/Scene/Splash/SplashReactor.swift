//
//  SplashReactor.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/30.
//

import RxCocoa
import RxSwift
import ReactorKit


final class SplashReactor: Reactor {

  let initialState: State = State()

  private let repository: AuthRepository = AuthRepositoryImp()

  enum Action {
    case viewWillAppear

  }

  enum Mutation {
    case setIsSuccessRefresh(Bool)
    case setIsOnboardingFlow(Bool)
    case setIsLoginFlow(Bool)
    case setShwoAlertByServerError(String?)
  }

  struct State {
    var isSuccessRefresh: Bool? = nil
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

    case .setIsSuccessRefresh(let isSuccess):
      newState.isSuccessRefresh = isSuccess

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
    let serviceMutation = repository.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .isSuccess(let isSuccess):
        return .just(.setIsSuccessRefresh(isSuccess))

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
          return .just(.setIsOnboardingFlow(true))
        }

        if status == 401 {
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
    let accessToken = Keychain.shared.getAccessToken() ?? ""
    let refreshToken = Keychain.shared.getRefreshToken() ?? ""

    repository.refresh(accessToken, refreshToken)

    return .empty()
  }
}
