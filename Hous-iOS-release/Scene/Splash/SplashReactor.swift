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
    case shwoAlertByServerError

  }

  enum Mutation {
    case setIsSuccessRefresh(Bool)
    case setIsOnboardingFlow(Bool)
    case setIsLoginFlow(Bool)
    case setShwoAlertByServerError
  }

  struct State {
    var isSuccessRefresh: Bool? = nil
    var isOnboardingFlow: Bool? = nil
    var isLoginFlow: Bool? = nil
    var shwoAlertByServerErrorFlag: Bool? = nil
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .empty()

    case .shwoAlertByServerError:
      return .just(.setShwoAlertByServerError)

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

    case .setShwoAlertByServerError:
      break
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

        if status == 404 {
          // MARK: - Login 화면으로

          if UserInformation.shared.isAlreadyOnboarding != nil {
            return .just(.setIsLoginFlow(true))
          }

          // MARK: - Onboarding Flow로

          else {
            UserInformation.shared.isAlreadyOnboarding = true
            return .just(.setIsOnboardingFlow(true))
          }
        }

        else {
          return .just(.setShwoAlertByServerError)
        }
      }
    }

    return Observable.merge(mutation, serviceMutation)
  }
}
