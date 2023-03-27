//
//  MainHomeSection.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/24.
//

import Foundation
import RxDataSources
import Network

struct MainHomeSectionModel {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case myTodos
    case ourTodos
    case homieProfiles
  }

  enum Item: Equatable {
    case myTodos(todos: MainHomeDTO.Response.MainHomeResponseDTO)
    case ourTodos(todos: MainHomeDTO.Response.MainHomeResponseDTO)
    case homieProfiles(profiles: MainHomeDTO.Response.HomieDTO)

    static func == (lhs: MainHomeSectionModel.Item, rhs: MainHomeSectionModel.Item) -> Bool {
      switch (lhs, rhs) {
      case (.myTodos, .myTodos),
        (.ourTodos, .ourTodos),
        (.homieProfiles, .homieProfiles):
        return true
      default:
        return false
      }
    }

  }
}
