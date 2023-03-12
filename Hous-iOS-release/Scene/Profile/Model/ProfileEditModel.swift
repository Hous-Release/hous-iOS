//
//  ProfileEditModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/07.
//

import Foundation

public struct ProfileEditModel: Equatable {
  var name: String
  var birthday: Date?
  var mbti: String
  var job: String
  var statusMessage: String
  var birthdayPublic: Bool
}

enum ProfileEditActionControl {
  case didTabBack
  case didTabSave
  case didTabBackgroundView

  case nameTextFieldSelected
  case nameTextFieldUnselected
  case nameTextFieldEdited(text: String)

  case birthdayTextFieldSelected
  case birthdayTextFieldUnselected
  case birthdayTextFieldEdited(date: Date?)
  case birthdayPublicEdited(isPublic: Bool)

  case mbtiTextFieldSelected
  case mbtiTextFieldUnselected
  case mbtiTextFieldEdited(text: String)

  case jobTextFieldSelected
  case jobTextFieldUnselected
  case jobTextFieldEdited(text: String)

  case statusTextViewSelected
  case statusTextViewUnselected
  case statusTextViewEdited(text: String)

  case none
}
