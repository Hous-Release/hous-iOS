//
//  MainTodoAPI.swift
//  
//
//  Created by 김지현 on 2022/10/01.
//

import Foundation

protocol MainTodoAPIProtocol {
    func getTodosData(completion: @escaping (BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>?, Error?) -> Void
  )
}

public final class MainTodoAPI: APIRequestLoader<MainTodoService>, MainTodoAPIProtocol {
    public func getTodosData(completion: @escaping (BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>?, Error?) -> Void) {
        fetchData(target: .getTodos,
                  responseData: BaseResponseType<MainTodoDTO.Response.MainTodoResponseDTO>.self,
                  isWithInterceptor: true) { res, err in
            completion(res, err)
        }
    }
}
