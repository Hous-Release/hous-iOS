//
//  BottomSheet+.swift
//  
//
//  Created by 김호세 on 2022/10/09.
//

import UIKit

public extension UIViewController {

  func presentPopUp(_ type: PopUpType) {
    let popupVC = PopUpViewController(popUpType: type)
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: true)
  }
}
