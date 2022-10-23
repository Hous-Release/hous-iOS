//
//  File.swift
//  
//
//  Created by 김호세 on 2022/10/30.
//

import UIKit
import Foundation

class DefaultPopUpAction: PopUpAction {

  let view: DefaultPopUpView
  var completeAction: CompleteAction?

  init(view: DefaultPopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
