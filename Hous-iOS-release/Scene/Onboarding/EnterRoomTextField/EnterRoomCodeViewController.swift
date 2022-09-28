//
//  EnterRoomCodeViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit

class EnterRoomCodeViewController: UIViewController {

  var mainView = EnterRoomTextFieldView(roomType: .exist)

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
  }
}
