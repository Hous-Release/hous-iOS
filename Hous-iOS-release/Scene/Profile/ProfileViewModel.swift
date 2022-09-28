//
//  ProfileViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

//Reference Link  : https://mildwhale.github.io/2020-04-16-mvvm-with-input-output/

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: IOViewModel {
  struct Dependency {
    
  }
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  let dependency: Dependency
  var disposeBag: DisposeBag = DisposeBag()
  let input: Input
  let output: Output
  
  init(dependency: Dependency = <# 초기화할 값들 #>) {
    self.dependency = dependency
    
    // Streams
    
    // Input & Output
    self.input = <#Input#>
    self.output = <#Output#>
    
    // Binding
  
  }
}
