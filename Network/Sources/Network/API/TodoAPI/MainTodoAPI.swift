//
//  TodoAPI.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation

protocol TodoAPIProtocol {

  // MARK: - todo main view
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

  func getModifyingTodo(
    todoID: Int,
    completion: @escaping (BaseResponseType<UpdateTodoDTO.ModifyTodo>?, Error?) -> Void
  )


  // MARK: - 요일별 todo view
  func getDaysOfWeekTodosData(
    completion: @escaping (BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>?, Error?
    ) -> Void
  )

  // MARK: - 멤버별 todo view
  func getMemberTodosData(
    completion: @escaping (
      BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>?, Error?
    ) -> Void
  )
}

public final class TodoAPI: APIRequestLoader<TodoService>, TodoAPIProtocol {

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

  public func getOnlyMyTodoData(
    completion: @escaping (BaseResponseType<FilteredTodoDTO.Response.OnlyMyTodosDTO>?,Error?) -> Void
  ) {
    fetchData(
      target: .getOnlyMyTodo,
      responseData: BaseResponseType<FilteredTodoDTO.Response.OnlyMyTodosDTO>.self,
      isWithInterceptor: true
    ) { res, err in
      completion(res, err)
    }
  }

  public func getModifyingTodo(
    todoID: Int,
    completion: @escaping (BaseResponseType<UpdateTodoDTO.ModifyTodo>?, Error?) -> Void
  ) {
    fetchData(
      target: .getModifyTodoID(todoID),
      responseData: BaseResponseType<UpdateTodoDTO.ModifyTodo>.self) { res, err in
        completion(res,err)
      }
  }


  // MARK: - 요일별
  public func getDaysOfWeekTodosData(completion: @escaping (BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>?, Error?) -> Void) {
    fetchData(target: .getDaysOfWeekTodos,
              responseData: BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>.self,
              isWithInterceptor: true) { res, err in
      completion(res, err)
    }
  }

  // MARK: - 멤버별
  public func getMemberTodosData(
      completion: @escaping (
        BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>?, Error?) -> Void
    ) {
      fetchData(
        target: .getMemberTodos,
        responseData: BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>.self,
        isWithInterceptor: true
      ) { res, err in
        completion(res, err)
      }
    }
}
