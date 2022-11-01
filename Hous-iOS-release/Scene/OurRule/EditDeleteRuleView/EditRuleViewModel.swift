//
//  EditRuleViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/02.
//

import Foundation
import RxSwift
import Network

final class EditRuleViewModel: ViewModelType {
  
  struct Input {
    let backButtonDidTap: Observable<Void>
    let saveButtonDidTap: Observable<[RuleWithIdViewModel]>
  }
  
  struct Output {
    
  }
  
  
  
  func transform(input: Input) -> Output {
    let output = Output()
    
    
    
    
    return output
  }
}
