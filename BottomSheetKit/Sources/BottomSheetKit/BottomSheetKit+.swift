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
    _ completion: CompletePopUpAction? = nil
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

    case .duplicate(let popUpModel):

      let view = DuplicationPopUpView(popUpModel)
      let popUpAction = DuplicationPopUpAction(view: view)
      let vc = DuplicationPopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)

    case .needUpdate(let popupModel):

      let view = NeedUpdatePopUpView(popupModel)
      let popUpAction = NeedUpdatePopUpAction(view: view)
      let vc = NeedUpdatePopUpViewController(popUpAction: popUpAction)

      popUpAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)
    }
  }
  func presentBottomSheet(
    _ type: BottomSheetType,
    _ completion: CompleteBottomSheetAction? = nil
  ) {

    switch type {

    case .defaultType:
      let view = DefaultBottomSheetView()
      let bottomSheetAction = DefaultBottomSheetAction(view: view)
      let vc = DefaultBottomSheetViewController(action: bottomSheetAction)

      bottomSheetAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)

    case .todoType(let model):
      let view = TodoBottomSheetView(model)
      let bottomSheetAction = TodoBottomSheetAction(view: view)
      let vc = TodoBottomSheetViewController(action: bottomSheetAction)

      bottomSheetAction.completeAction = { actionType in
        completion?(actionType)
      }

      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overFullScreen
      present(vc, animated: true)
    case .ruleType(let model):
        let view = RuleBottomSheetView(model: model)
        let bottomSheetAction = RuleBottomSheetAction(view: view)
        guard let viewController = RuleBottomSheetViewController(action: bottomSheetAction) else { return }

        bottomSheetAction.completeAction = { actionType in
            completion?(actionType)
        }

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false) {
            viewController.showBottomSheetWithAnimation()
        }
    case .ruleGuideType:
        let view = RuleGuideBottomSheetView()
        let bottomSheetAction = RuleGuideBottomSheetAction(view: view)
        guard let viewController = RuleGuideBottomSheetViewController(action: bottomSheetAction) else { return }

        bottomSheetAction.completeAction = { actionType in
            completion?(actionType)
        }

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false) {
            viewController.showBottomSheetWithAnimation()
        }
    }

  }
}
