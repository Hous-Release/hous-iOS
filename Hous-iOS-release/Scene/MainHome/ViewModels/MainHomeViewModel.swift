//
//  HousViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/08.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MainHomeViewModel: ViewModelType {
  
  private let disposeBag = DisposeBag()
  
  //MARK: - Input
  struct Input {
    let viewWillAppear: Observable<Void>
    let editButtonDidTapped: Observable<Void>
    let copyCodeButtonDidTapped: Observable<Void>
    let moreMyTodoButtonDidTapped: Observable<Void>
    let moreOurRulesButtonDidTapped: Observable<Void>
    let profileDidTapped: Observable<Void>
  }
  
  //MARK: - Output
  struct Output {
    var titleText = BehaviorRelay<String>(value: "")
    var todoProgress = BehaviorRelay<Int>(value: 0)
    var todoTexts = BehaviorRelay<[String]>(value: [])
    var ourRulesTexts = BehaviorRelay<[String]>(value: [])
    var homies = BehaviorRelay<[HomieModel]>(value: [])
//    let lottie: BehaviorRelay<String>
  }
  
  func transform(input: Input) -> Output {
    let output = Output()
    
    return output
  }
  
  
  
}
