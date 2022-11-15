//
//  ProfileTestModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/12.
//

import Foundation
import Network

enum ProfileTestInfoActionControl {
  case didTabBack
  case none
}

struct ProfileTestCellItem {
  let testTitle: String
  let testIdx: Int
  let testImg: String
  let testType: String
  var testAnswers: [ProfileTestButtonState]
  
  init(dto: ProfileDTO.Response.ProfileTestResponseDTO) {
    self.testTitle = dto.question
    self.testIdx = dto.testNum
    self.testImg = dto.questionImg
    self.testType = dto.questionType
    
    var t: [ProfileTestButtonState] = []
    for answer in dto.answers {
      let button = ProfileTestButtonState(optionText: answer, isSelected: false)
      t.append(button)
    }
    self.testAnswers = t
  }
}

struct ProfileTest {
  var questionType: String
  var score: Int
  
  init(testType: String, score: Int) {
    self.questionType = testType
    self.score = score
  }
}

class ProfileTestButtonState {
  var optionText: String
  var isSelected: Bool
  
  init(optionText: String, isSelected: Bool) {
    self.optionText = optionText
    self.isSelected = isSelected
  }
  
  func deselectIsSelected() {
    isSelected = false
  }
}
