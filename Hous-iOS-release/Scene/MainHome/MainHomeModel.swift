//
//  MainHomeModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/10.
//

import Foundation

struct MainHomeModel {
  let userNickname: String
  let roomName: String
  let progress: Int
  let myTodos: [String]
  let ourRules: [String]
  let homies: [HomieModel]
}

struct HomieModel {
  let color: String
  let userNickname: String
}
