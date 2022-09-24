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
    urlRequest.setValue("Bearer eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjoxLCJleHAiOjE2OTQ2NzYxNjh9.qkYdHxX4MIWJmhGzyyeWctsaJTq6s9Wj0MDvgJ2XzX1Empm6mo2o8TrcuLV_tg84vCEquR8FWV_GKfPWmnfFxw", forHTTPHeaderField: "Authorization")
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
