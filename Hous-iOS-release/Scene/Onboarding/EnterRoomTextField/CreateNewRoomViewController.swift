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
    setup()
  }

  private func setup() {
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
  }
}

extension CreateNewRoomViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
