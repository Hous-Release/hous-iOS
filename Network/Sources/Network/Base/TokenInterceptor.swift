//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation
import Alamofire
import UserInformation

internal final class TokenInterceptor: RequestInterceptor, RequestRetrier {
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    var urlRequest = urlRequest

    let value = Keychain.shared.getAccessToken() ?? ""
    urlRequest.setValue("Bearer \(value)", forHTTPHeaderField: "Authorization")
    completion(.success(urlRequest))
  }

  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {

    guard
      let response = request.task?.response as? HTTPURLResponse,
      request.retryCount < 3,
      response.statusCode == 401
    else {
      completion(.doNotRetry)
      return
    }

    let token = Token(
      accessToken: Keychain.shared.getAccessToken() ?? "",
      refreshToken: Keychain.shared.getRefreshToken() ?? ""
    )

    NetworkService.shared.authRepository.refresh(token) { res, err in

      guard let res = res else {
        completion(.retry)
        return
      }

      if res.status == 200 {
        Keychain.shared.setAccessToken(accessToken: res.data?.token.accessToken)
        Keychain.shared.setRefreshToken(refreshToken: res.data?.token.refreshToken)
        completion(.retry)
      }
    }
  }
}
