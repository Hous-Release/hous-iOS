//
//  CreateNewRoomViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit

class CreateNewRoomViewController: UIViewController {

  var mainView = EnterRoomTextFieldView(roomType: .new)

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
  }
}
