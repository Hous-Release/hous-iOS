//
//  APIError.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

public enum APIError {
  enum APIError: Error {

    case requestFailed(description: String)
    case jsonConversionFailure(description: String)
    case invalidData
    case responseUnsuccessful(description: String)
    case jsonParsingFailure
    case noInternet
    case failedSerialization

    var customDescription: String {
      switch self {
      case let .requestFailed(description): return "Request Failed error -> \(description)"
      case .invalidData: return "Invalid Data error)"
      case let .responseUnsuccessful(description): return "Response Unsuccessful error -> \(description)"
      case .jsonParsingFailure: return "JSON Parsing Failure error)"
      case let .jsonConversionFailure(description): return "JSON Conversion Failure -> \(description)"
      case .noInternet: return "No internet connection"
      case .failedSerialization: return "serialization print for debug failed."
      }
    }
  }
}
