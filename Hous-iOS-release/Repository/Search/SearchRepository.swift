//
//  SearchRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/06/30.
//

import Foundation
import Combine
import Network
import UIKit.UIImage

protocol SearchRepository {

  associatedtype SearchItem

  /// Runs  search with a query string
  func search(with name: String) -> AnyPublisher<Result<[SearchItem], Error>, Never>

  /// Fetches details for searchResult with specified id
  func getDetail(with id: Int) -> AnyPublisher<Result<SearchItem, Error>, Never>
}

//final class SearchRuleRepositoryImp: SearchRepository {
//
//  private let type: SearchType
//  typealias SearchItem = HousRule
//
//  init(searchType: SearchType) {
//      self.type = searchType
//  }
//// 6/30 todo : newtodoapi newtodosevice combine 리턴 형태로 리팩토링 한 다음 여기서부터 시작하기
//  func search(with name: String) -> AnyPublisher<Result<[SearchItem], Error>, Never> {
//
//  }
//
//  func getDetail(with id: Int) -> AnyPublisher<Result<SearchItem, Error>, Never> {
//
//  }
//}
