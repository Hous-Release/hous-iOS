//
//  BaseService.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/08.
//

import Foundation

public class BaseService {
  unowned let provider: ServiceProviderType

  public init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
