//
//  RulesViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation
import RxSwift

class RulesViewModel {
  var dummy: [String]
  
  init(dummy: [String]) {
    self.dummy = dummy
  }
  
  func getCellData() -> Observable<[String]> {
    return Observable.of(dummy)
  }
}
