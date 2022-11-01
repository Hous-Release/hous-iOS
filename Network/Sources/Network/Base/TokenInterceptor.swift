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
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    var urlRequest = urlRequest

    let value = Keychain.shared.getAccessToken() ?? "eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjozLCJleHAiOjE2OTc5NjM0ODh9.yG1Jc3FngP7zzJtj_1v4fw0PwrAhu8ovS1rMo7ob_uzbrqgDoYZXKVIpuwkWdZ5W0ySlCYgvW--e4e8N2KMLdw"
    urlRequest.setValue("Bearer \(value)", forHTTPHeaderField: "Authorization")


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
