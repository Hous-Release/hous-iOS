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
  var multipart: MultipartFormData { get }
}

public enum API {
  static var apiBaseURL: String {
    return try! "http://" + Configuration.value(for: "API_BASE_URL")
  }
}

enum HTTPHeaderField: String {
  case authentication = "Authorization"
  case contentType = "Content-Type"
  case acceptType = "Accept"
  case housOSType = "HousOsType"
  case housVersion = "HousVersion"
}

public enum ContentType: String {
  case json = "Application/json"
  case image = "image/jpeg"
  case multipart = "multipart/form-data"
}

public enum RequestParams {
  case requestPlain
  case query(_ parameter: Encodable?)
  case body(_ parameter: Encodable?)

}

extension TargetType {

  public func asURLRequest() throws -> URLRequest {

    let url = try baseURL.asURL()

    var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
    urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
    urlRequest.addValue("iOS", forHTTPHeaderField: HTTPHeaderField.housOSType.rawValue)
    guard let version = Bundle.main.object(forInfoDictionaryKey: "MARKETING_VERSION") else {
      fatalError("There is Not Version")
    }
    urlRequest.addValue(version as! String, forHTTPHeaderField: HTTPHeaderField.housVersion.rawValue)

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

  var multipart: MultipartFormData {
    return MultipartFormData()
  }
}
