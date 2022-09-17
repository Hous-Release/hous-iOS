//
//  MainHomeRepository.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import Foundation
import RxSwift

protocol MainHomeRepository {
  func getHomeData() -> Observable<MainHomeDTO?>
}

final class DefaultMainHomeRepsository: MainHomeRepository {

  private let service: MainHomeServiceType
  private let disposeBag = DisposeBag()
  
  init(service: MainHomeServiceType) {
    self.service = service
  }
  
  func getHomeData() -> Observable<MainHomeDTO?> {
    return service.getHomeData()
  }
}
