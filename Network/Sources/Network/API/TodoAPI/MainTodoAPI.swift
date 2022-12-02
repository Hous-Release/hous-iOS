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
  func getAssignees(
    completion: @escaping (
      BaseResponseType<MainTodoDTO.Response.AssigneeDTO>?, Error?
    ) -> Void
  )
  func checkTodo(
    _ todoId: Int,
    _ status: Bool,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  )
  func getTodoSummary(
    _ todoId: Int,
    completion: @escaping (BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>?, Error?
    ) -> Void
  )
  func updateTodo(
    _ id: Int?,
    _ dto: UpdateTodoDTO.ModifyTodo,
    completion: @escaping (BaseResponseType<String>?, Error?
                          ) -> Void
  )
  func deleteTodo(
    _ todoId: Int,
    completion: @escaping (BaseResponseType<String>?, Error?
                          ) -> Void
  )
}

public final class MainTodoAPI: APIRequestLoader<MainTodoService>, MainTodoAPIProtocol {

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
  public func getAssignees(
    completion: @escaping (BaseResponseType<MainTodoDTO.Response.AssigneeDTO>?, Error?) -> Void) {
      fetchData(
        target: .getAssignees,
        responseData: BaseResponseType<MainTodoDTO.Response.AssigneeDTO>.self
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

  public func getTodoSummary(
    _ todoId: Int,
    completion: @escaping (BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>?, Error?
    ) -> Void) {
    fetchData(
      target: .getTodoSummary(todoId),
      responseData: BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>.self
    ) { res, err in
        completion(res, err)
      }
  }

  public func updateTodo(
    _ id: Int? = nil,
    _ dto: UpdateTodoDTO.ModifyTodo,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  ) {
    fetchData(
      target: .updateTodo(id, dto),
      responseData: BaseResponseType<String>.self
    ) { res, err in
      completion(res, err)
    }
  }

  public func deleteTodo(
    _ todoId: Int,
    completion: @escaping (BaseResponseType<String>?, Error?
    ) -> Void
  ) {
    fetchData(
      target: .deleteTodo(todoId),
      responseData: BaseResponseType<String>.self
    ) { res, err in
      completion(res, err)
    }
  }
}
