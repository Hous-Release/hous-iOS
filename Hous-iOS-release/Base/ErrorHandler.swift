//
//  ErrorHandler.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2023/03/08.
//

import BottomSheetKit
import UIKit

protocol ErrorHandler {
  func handleError(_ error: HouseErrorModel?)
}

extension ErrorHandler where Self: BaseViewController {

  func handleError(_ error: HouseErrorModel?) {
    guard
      let errorModel = error,
      let errorMessage = errorModel.message
    else {
      return
    }

    Toast.show(message: errorMessage, controller: self)
  }

}
