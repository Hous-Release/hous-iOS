//
//  ProfileTestModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/12.
//

import Foundation
import Network

enum ProfileTestActionControl {
  case didTabQuit
  case didTabForward
  case didTabBackward
  case didTabAnswer(answer: Int, questionNum: Int)
  case didTabFinish
  case none
}

enum ProfileTestInfoActionControl {
  case didTabBack
  case none
}

public struct ProfileTestItemModel {
  let question: String
  let questionNum: Int
  let questionImg: String
  let questionType: String
  var testAnswers: [ProfileTestButtonState]
  
  init(question: [String], questionNum: Int, questionImg: String, questionType: String, answers: [[String]]) {
    
    var questionCombined: String = ""
    for line in question {
      questionCombined += (line + "\n")
    }
    
    if questionCombined.count > 2 {
      let start = questionCombined.startIndex
      let end = questionCombined.index(questionCombined.endIndex, offsetBy: -2)
      self.question = String(questionCombined[start...end])
    } else { self.question = ""}
    
    self.questionNum = questionNum
    self.questionImg = questionImg
    self.questionType = questionType
    
    var buttons: [ProfileTestButtonState] = []
    for answer in answers {
      var answerCombined: String = ""
      var processedAnswer = ""
      for line in answer {
        answerCombined += (line + "\n")
      }
      
      if answerCombined.count > 2 {
        let start = answerCombined.startIndex
        let end = answerCombined.index(answerCombined.endIndex, offsetBy: -2)
        processedAnswer = String(answerCombined[start...end])
      }
      
      let button = ProfileTestButtonState(optionText: processedAnswer, isSelected: false)
      buttons.append(button)
    }
    
    self.testAnswers = buttons
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
  
  func deselectButton() {
    isSelected = false
  }
  
  func selectButton() {
    isSelected = true
  }
}
