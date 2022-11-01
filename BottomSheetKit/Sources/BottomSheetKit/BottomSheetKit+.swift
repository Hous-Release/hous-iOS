//
//  BottomSheet+.swift
//  
//
//  Created by 김호세 on 2022/10/09.
//

import UIKit

public extension UIViewController {

  func presentPopUp(
    _ type: PopUpType,
    _ completion: CompleteAction? = nil
  ) {

    switch type {
    case .defaultPopUp(let twoButtonPopUpModel):

      let view = DefaultPopUpView(twoButtonPopUpModel)
      let popUpAction = DefaultPopUpAction(view: view)
      let vc = DefaultPopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)

    case .copyCode(let copyCodePopUpModel):

      let view = CopyCodePopUpView(copyCodePopUpModel)
      let popUpAction = CopyCodePopUpAction(view: view)
      let vc = CopyCodePopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)
    }
  }
}
