//
//  ResignReasonType.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/10.
//

import Foundation

enum ResignReasonType: String, CustomStringConvertible {

  case no = "사유 선택하기"
  case doneLivingTogether = "공동생활이 끝나서"
  case inconvenientToUse = "이용이 불편하고 장애가 많아서"
  case lowUsage = "사용 빈도가 낮아서"
  case contentsUnsatisfactory = "콘텐츠가 만족스럽지 않아서"
  case etc = "기타"

  var description: String {
    switch self {
    case .no:
      return "NO"
    case .doneLivingTogether:
      return "DONE_LIVING_TOGETHER"
    case .inconvenientToUse:
      return "INCONVENIENT_TO_USE"
    case .lowUsage:
      return "LOW_USAGE"
    case .contentsUnsatisfactory:
      return "CONTENTS_UNSATISFACTORY"
    case .etc:
      return "ETC"
    }
  }
}
