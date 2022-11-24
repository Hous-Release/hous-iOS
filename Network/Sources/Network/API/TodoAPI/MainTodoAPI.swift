//
//  MainTodoAPI.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation

protocol MainTodoAPIProtocol {
  func getTodosData(
    completion: @escaping (
      BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>?, Error?
    ) -> Void
  )
  func getMembers(
    completion: @escaping (
      BaseResponseType<MainTodoDTO.Response.MemberDTO>?, Error?
    ) -> Void
  )
  func checkTodo(
    _ todoId: Int,
    _ status: Bool,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  )
  func addTodo(
    _ dto: UpdateTodoDTO.ModifyTodo,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  )
}

public final class MainTodoAPI: APIRequestLoader<MainTodoService>, MainTodoAPIProtocol {
  public func addTodo(
    _ dto: UpdateTodoDTO.ModifyTodo,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  ) {
    fetchData(
      target: .addTodo(dto),
      responseData: BaseResponseType<String>.self
    ) { res, err in
      completion(res, err)
    }
  }

  public func checkTodo(
    _ todoId: Int,
    _ status: Bool,
    completion: @escaping (BaseResponseType<String>?, Error?) -> Void
  ) {
    let statusDTO = MainTodoDTO.Request.updateTodoRequestDTO(status: status)
    fetchData(
      target: .checkTodo(todoId, statusDTO),
      responseData: BaseResponseType<String>.self
    ) { res, err in
      completion(res, err)
    }
  }
  public func getMembers(
    completion: @escaping (BaseResponseType<MainTodoDTO.Response.MemberDTO>?, Error?) -> Void) {
      fetchData(
        target: .getMembers,
        responseData: BaseResponseType<MainTodoDTO.Response.MemberDTO>.self
      ) { res, err in
        completion(res, err)
      }
    }

  public func getTodosData(
    completion: @escaping (BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>?, Error?
    ) -> Void) {
    fetchData(
      target: .getTodos,
      responseData: BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>.self
    ) { res, err in
      completion(res, err)
    }
  }
}
