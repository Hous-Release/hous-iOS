//
//  TargetType.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation
import Alamofire

public protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: RequestParams { get }
  var contentType: ContentType { get }
}

enum Configuration {
  enum Error: Swift.Error {
    case missingKey, invalidValue
  }

  static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
      throw Error.missingKey
    }

    switch object {
    case let value as T:
      return value
    case let string as String:
      guard let value = T(string) else { fallthrough }
      return value
    default:
      throw Error.invalidValue
    }
  }
}

public enum API {

  static var apiBaseURL: String {
    return try! "https://" + Configuration.value(for: "API_BASE_URL")
  }
}

enum HTTPHeaderField: String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
  case acceptType = "Accept"
}

public enum ContentType: String {
  case json = "Application/json"
  case image = "image/jpeg"
}

public enum RequestParams {
  case requestPlain
  case query(_ parameter: Encodable?)
  case body(_ parameter: Encodable?)}

extension TargetType {

  public func asURLRequest() throws -> URLRequest {

    let url = try baseURL.asURL()

    var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
    urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

    switch parameters {

    case .query(let request):

      let params = request?.toDictionary() ?? [:]
      let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
      var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)

      components?.queryItems = queryParams
      urlRequest.url = components?.url

    case .body(let request):
      let params = request?.toDictionary() ?? [:]
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])


    case .requestPlain:
      break
    }

    return urlRequest
  }
}

public extension TargetType {
  var contentType: ContentType {
    return .json
  }
}
