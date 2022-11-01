//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

final public class NetworkService {
  public static var shared = NetworkService()
  
  private init() { }
  
  public let authRepository = AuthAPI(isLogging: true)
  public let mainHomeRepository = MainHomeAPI(isLogging: true)
  public let mainTodoRepository = MainTodoAPI(isLogging: true)
  public let roomRepository = RoomAPI(isLogging: true)
  public let profileRepository = ProfileAPI(isLogging: true)
  public let ruleRepository = RuleAPI(isLogging: true)
}
