//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/05.
//

import Foundation

class ExceedPopUpAction: PopUpAction {

  let view: ExceedPopUpView
  var completeAction: CompleteAction?

  init(view: ExceedPopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
