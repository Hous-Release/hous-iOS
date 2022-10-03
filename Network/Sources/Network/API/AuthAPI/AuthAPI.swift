//
//  AuthAPI.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

protocol AuthAPIProtocol {

  func login(
    _ loginRequestDTO: AuthDTO.Request.LoginRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void
  )
  func refresh(
    _ refreshRequestDTO: Token,
    completion: @escaping (BaseResponseType<Token>?, Error?) -> Void
  )
}

public final class AuthAPI: APIRequestLoader<AuthService>, AuthAPIProtocol {
  public func refresh(
    _ refreshRequestDTO: Token,
    completion: @escaping (BaseResponseType<Token>?, Error?) -> Void) {
    fetchData(
      target: .refresh(refreshRequestDTO),
      responseData: BaseResponseType<Token>.self,
      isWithInterceptor: false
    ) { res, err in
        completion(res, err)
      }
  }

  public func login(
    _ loginRequestDTO: AuthDTO.Request.LoginRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .login(loginRequestDTO),
      responseData: BaseResponseType<AuthDTO.Response.LoginResponseDTO>.self,
      isWithInterceptor: false
    ) { res, err in
        completion(res, err)
      }
  }
}
