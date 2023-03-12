//
//  ProfileDetailModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import Foundation

public struct ProfileDetailModel {
  var personalityType: PersonalityColor
  var badPersonalityImageURL: String
  var badPersonalityName: String
  var goodPersonalityImageURL: String
  var goodPersonalityName: String
  var imageURL: String
  var name: String
  var recommendTitle: String
  var recommendTodo: [String]
  var title: String
  var description: [String]

  init() {
    personalityType = .none
    badPersonalityName = ""
    badPersonalityImageURL = ""
    goodPersonalityName = ""
    goodPersonalityImageURL = ""
    imageURL = ""
    name = ""
    recommendTodo = []
    recommendTitle = ""
    title = ""
    description = []
  }

  init(personalityType: PersonalityColor, badPersonalityImageURL: String, badPersonalityName: String,
       goodPersonalityImageURL: String, goodPersonalityName: String, imageURL: String, name: String,
       recommendTitle: String, recommendTodo: [String], title: String, description: [String]) {

    self.personalityType = personalityType
    self.badPersonalityImageURL = badPersonalityImageURL
    self.badPersonalityName = badPersonalityName
    self.goodPersonalityImageURL = goodPersonalityImageURL
    self.goodPersonalityName = goodPersonalityName
    self.imageURL = imageURL
    self.name = name
    self.recommendTodo = recommendTodo
    self.recommendTitle = recommendTitle
    self.title = title
    self.description = description
  }
}

enum ProfileDetailActionControl {
  case didTabBack
  case none
}
