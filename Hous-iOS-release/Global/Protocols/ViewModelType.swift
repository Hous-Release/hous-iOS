//
//  ViewModelType.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/10.
//

import Foundation
import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}
