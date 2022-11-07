//
//  ProfileEditModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/07.
//

import Foundation

struct ProfileEditModel {
  let name: String?
  let birthday: Date?
  let mbti: String?
  let job: String?
  let statusMessage: String?
  let birthdayPublic: Bool
}


enum ProfileEditActionControl {
  case didTabBackModified
  case didTabBackNotModified
  case didTabSave
  case nameTextFieldSelected
  case nameTextFieldUnselected
  case birthdayTextFieldSelected
  case birthdayTextFieldUnselected
  case mbtiTextFieldSelected
  case mbtiTextFieldUnselected
  case jobTextFieldSelected
  case jobTextFieldUnselected
  case statusTextFieldSelected
  case statusTextFieldUnselected
  case none
}
