//
//  Protocols.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import Foundation
import RxSwift

protocol IOViewModel {
  associatedtype Dependency
  associatedtype Input
  associatedtype Output
  
  var dependency: Dependency { get }
  var disposeBag: DisposeBag { get set }
  
  var input: Input { get }
  var output: Output { get }
  
  init(dependency: Dependency)
}
