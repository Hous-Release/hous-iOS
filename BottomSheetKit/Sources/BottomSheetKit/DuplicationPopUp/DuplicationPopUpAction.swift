//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/05.
//


import Foundation
import UIKit

class DuplicationPopUpAction: PopUpAction {

  let view: DuplicationPopUpView
  var completeAction: CompleteAction?

  init(view: DuplicationPopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
