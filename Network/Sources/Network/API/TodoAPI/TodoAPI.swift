//
//  TodoAPI.swift
//  
//
//  Created by 김지현 on 2023/06/30.
//

import Foundation
import Alamofire
import Combine

protocol NewTodoAPIProtocol {

  ///  FilterTodoViewController CollectionView Cell에 띄울 result
  func getTodoByFilter(
    dto: FilteredTodoDTO.Request.getTodosFilteredRequestDTO
  ) -> AnyPublisher<BaseResponseType<FilteredTodoDTO.Response.FilteredTodoResponseDTO>, AFError>

  // MainTodoDTO depecreted 예정
  /// FilterTodoViewController CollectionView Cell 클릭시 가져올 Detail result
  func getTodoDetail(
    todoId: Int
  ) -> AnyPublisher<BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>, AFError>
}

public final class NewTodoAPI: APIRequestLoader<NewTodoService>, NewTodoAPIProtocol {

  func getTodoByFilter(
    dto: FilteredTodoDTO.Request.getTodosFilteredRequestDTO
  ) -> AnyPublisher<BaseResponseType<FilteredTodoDTO.Response.FilteredTodoResponseDTO>, AFError> {

    return fetchDataToPublisher(
      target: .getTodoByFilter(dto),
      responseData: BaseResponseType<FilteredTodoDTO.Response.FilteredTodoResponseDTO>.self
    )
  }

  func getTodoDetail(
    todoId: Int
  ) -> AnyPublisher<BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>, AFError> {

    return fetchDataToPublisher(
      target: .getTodoDetail(todoId),
      responseData: BaseResponseType<MainTodoDTO.Response.TodoSummaryResponseDTO>.self
    )

    }


}
