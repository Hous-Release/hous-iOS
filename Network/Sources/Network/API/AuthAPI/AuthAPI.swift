//
//  AuthAPI.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

protocol AuthAPIProtocol {
    
  func logout(
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void
  )

  func forceLogin(
    _ loginRequestDTO: AuthDTO.Request.LoginRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void
  )

  func login(
    _ loginRequestDTO: AuthDTO.Request.LoginRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void
  )
  func refresh(
    _ refreshRequestDTO: Token,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void
  )
  func signup(
    _ signupReauestDTO: AuthDTO.Request.SignupRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.SignupResponseDTO>?, Error?) -> Void
  )
}

public final class AuthAPI: APIRequestLoader<AuthService>, AuthAPIProtocol {
    
  public func logout(
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .logout,
      responseData: BaseResponseType<AuthDTO.Response.LoginResponseDTO>.self,
      isWithInterceptor: false
    ) { res, err in
        completion(res, err)
      }
  }

  public func forceLogin(
    _ loginRequestDTO: AuthDTO.Request.LoginRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .forceLogin(loginRequestDTO),
      responseData: BaseResponseType<AuthDTO.Response.LoginResponseDTO>.self,
      isWithInterceptor: false
    ) { res, err in
        completion(res, err)
      }
  }

  public func refresh(
    _ refreshRequestDTO: Token,
    completion: @escaping (BaseResponseType<AuthDTO.Response.LoginResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .refresh(refreshRequestDTO),
      responseData: BaseResponseType<AuthDTO.Response.LoginResponseDTO>.self,
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

  public func signup(
    _ signupReauestDTO: AuthDTO.Request.SignupRequestDTO,
    completion: @escaping (BaseResponseType<AuthDTO.Response.SignupResponseDTO>?, Error?) -> Void) {
    fetchData(
      target: .signup(signupReauestDTO),
      responseData: BaseResponseType<AuthDTO.Response.SignupResponseDTO>.self,
      isWithInterceptor: false
    ) { res, err in
        completion(res, err)
      }
  }
}
