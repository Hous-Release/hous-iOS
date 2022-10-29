//
//  RuleRepository.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/29.
//

import Foundation
import Network
import RxSwift


enum RuleRepositroyEvent {
  case ruleData([RuleDTO.Response.Rule])
  case sendError(HouseErrorModel?)
}

protocol RuleAPI {
  func getData()
}

final class RuleRepositoryImp: RuleAPI {
  var ruleSubject = PublishSubject<[RuleDTO.Response.Rule]>()
  
  func getData() {
    NetworkService.shared.ruleRepository.getRulesName { res, error in
      guard let self = self else { return }
      guard let data = res?.data else { return }
      self.ruleSubject.onNext(data.rules)
    }
  }
  
}
