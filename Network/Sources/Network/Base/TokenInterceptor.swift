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

    let value = Keychain.shared.getAccessToken() ?? "eyJhbGciOiJIUzUxMiJ9.eyJVU0VSX0lEIjoxMiwiZXhwIjoxNjk4OTE0MTk5fQ.seQoe7uoHX8hXlellquf25-ZEEj9fCDFApNThc91ZF9l9otmr2Zwin7nzsWB_x1Rx8-zYRhF0g2bLuDFE_tY_w"
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
