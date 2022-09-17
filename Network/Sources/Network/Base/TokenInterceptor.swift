//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation
import Alamofire


internal final class TokenInterceptor: RequestInterceptor, RequestRetrier {
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    var urlRequest = urlRequest
    urlRequest.setValue("Bearer eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjoyLCJleHAiOjE2OTQ3NjY3NjJ9.uiIUSb6-F_BO5HQYxNOEb5zo8W7rorg7YUXjmgu-zKc0slYUu54jjQo-K6bnskKkRwXkeyIE2CieXfCk0W5SuQ", forHTTPHeaderField: "Authorization")
    completion(.success(urlRequest))
  }

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    guard
      let response = request.task?.response as? HTTPURLResponse,
      request.retryCount < 3,
      response.statusCode == 401
    else {
      return
    }
  }
}
