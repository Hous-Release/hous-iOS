//
//  ProfileDTO.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit

enum PersonalityColor: Codable {
  case red
  case blue
  case yellow
  case green
  case purple
  case none
}


struct ProfileDTO: Codable {
  let personalityColor: PersonalityColor
  let userName, userJob, statusMessage, bedgeImage: String
  let hashTags: [String]
  let typeScores: [Double]
  let isEmptyView: Bool
}
