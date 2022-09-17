//
//  BaseResponseType.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

public struct BaseResponseType<T: Decodable>: Decodable {

  public let status: Int
  public let success: String
  public let message: String
  public let data: T?
}

public struct BaseErrorResponseType: Decodable {
  public let status: Int
  public let message: String
  public let name: String
}
