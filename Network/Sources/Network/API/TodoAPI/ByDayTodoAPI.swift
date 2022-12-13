//
//  File 2.swift
//  
//
//  Created by 김지현 on 2022/11/11.
//

import Foundation

protocol ByDayTodoAPIProtocol {
    func getDaysOfWeekTodosData(completion: @escaping (BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>?, Error?) -> Void
  )
}

public final class ByDayTodoAPI: APIRequestLoader<ByDayTodoService>, ByDayTodoAPIProtocol {
    public func getDaysOfWeekTodosData(completion: @escaping (BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getDaysOfWeekTodos,
                  responseData: BaseResponseType<ByDayTodoDTO.Response.ByDayTodosResponseDTO>.self,
                  isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }

    public func getOnlyMyTodoData(completion: @escaping (BaseResponseType<ByDayTodoDTO.Response.OnlyMyTodoDTO>?, Error?) -> Void) {
        fetchData(target: .getOnlyMyTodo,
                  responseData: BaseResponseType<ByDayTodoDTO.Response.OnlyMyTodoDTO>.self,
                  isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
}
