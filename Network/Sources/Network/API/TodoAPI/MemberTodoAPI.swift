//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/01.
//

import Foundation

protocol MemberTodoAPIProtocol {
    func getMemberTodosData(completion: @escaping (BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>?, Error?) -> Void
  )
}

public final class MemberTodoAPI: APIRequestLoader<MemberTodoService>, MemberTodoAPIProtocol {
    public func getMemberTodosData(completion: @escaping (BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getMemberTodos,
                  responseData: BaseResponseType<MemberTodoDTO.Response.MemberTodosResponseDTO>.self,
                  isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
}