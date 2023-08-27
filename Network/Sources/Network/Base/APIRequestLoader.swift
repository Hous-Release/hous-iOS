//
//  APIRequestLoader.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation
import Alamofire
import Combine

public class APIRequestLoader<T: TargetType> {

  let coniguration: URLSessionConfiguration
  let apiLogger = APIEventLogger()
  let tokenInterceptor = TokenInterceptor()
  let session: Session
  let sessionWithInterceptor: Session

  public init(
    configuration: URLSessionConfiguration = .default,
    isLogging: Bool = false
  ) {

    let apiLogger = isLogging ? [APIEventLogger()] : []

    self.coniguration = configuration
    self.session = Session(
      configuration: configuration,
      eventMonitors: apiLogger
    )
    self.sessionWithInterceptor = Session(
      configuration: configuration,
      interceptor: tokenInterceptor,
      eventMonitors: apiLogger
    )
  }

  internal func fetchData<M: Decodable>(
    target: T,
    responseData: M.Type,
    isWithInterceptor: Bool = true,
    completionHandler: @escaping (M?, Error?) -> Void
  ) {

    var allStatusCode = Set(200..<503)
    let session = isWithInterceptor ? self.sessionWithInterceptor : self.session
    _ = isWithInterceptor ? allStatusCode.remove(401) : nil

    session.request(target)
      .validate(statusCode: allStatusCode)
      .responseDecodable(of: M.self) { response in

      switch response.result {

        case .success(let data):
          completionHandler(data, nil)

        case .failure(let error):
          completionHandler(nil, error)
        }
      }
  }

    internal func fetchDataMultiPart<M: Decodable>(
      target: T,
      responseData: M.Type,
      isWithInterceptor: Bool = true,
      completionHandler: @escaping (M?, Error?) -> Void
    ) {

      var allStatusCode = Set(200..<503)
      let session = isWithInterceptor ? self.sessionWithInterceptor : self.session
      _ = isWithInterceptor ? allStatusCode.remove(401) : nil

        session.upload(multipartFormData: target.multipart, with: target)
            .validate(statusCode: allStatusCode)
            .responseDecodable(of: M.self) { response in

        switch response.result {
          case .success(let data):
            completionHandler(data, nil)

          case .failure(let error):
            print(String(describing: error))
            completionHandler(nil, error)
          }
        }
    }

    internal func fetchDataToPublisher<M: Decodable>(
      target: T,
      responseData: M.Type,
      isWithInterceptor: Bool = true
    ) -> AnyPublisher<M, AFError> {

      var allStatusCode = Set(200..<503)
      let session = isWithInterceptor ? self.sessionWithInterceptor : self.session
      _ = isWithInterceptor ? allStatusCode.remove(401) : nil

      return session.request(target)
        .validate(statusCode: allStatusCode)
        .publishDecodable(type: M.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

}
