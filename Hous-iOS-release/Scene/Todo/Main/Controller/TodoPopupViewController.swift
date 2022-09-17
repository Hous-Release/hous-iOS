//
//  TodoPopupViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/16.
//

import UIKit

class TodoPopupViewController: UIViewController {

  let mainView = TodoPopupView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    if let touch = touches.first,
       touch.view == self.view {
      dismiss(animated: true)
    }
  }
}
