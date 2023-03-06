//
//  OAuthable.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation

public typealias Success = ((String, String?) -> Void)
public typealias Failure = ((Error) -> Void)

public protocol OAuthable {
  func login()
  var onSuccess: Success? { get set }
  var onFailure: Failure? { get set }
}
