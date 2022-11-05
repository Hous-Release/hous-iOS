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

    case .enterRoom(let popupModel):

      let view = EnterRoomPopUpView(popupModel)
      let popUpAction = EnterRoomPopUpAction(view: view)
      let vc = EnterRoomPopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)

    case .exceed(exceedModel: let popupModel):

      let view = ExceedPopUpView(popupModel)
      let popUpAction = ExceedPopUpAction(view: view)
      let vc = ExceedPopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)
    }
  }
}
