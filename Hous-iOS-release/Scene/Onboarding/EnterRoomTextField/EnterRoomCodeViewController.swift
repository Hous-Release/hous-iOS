//
//  EnterRoomCodeViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit

final class EnterRoomCodeViewController: UIViewController {

  var mainView = EnterRoomTextFieldView(roomType: .exist)

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
    mainView.textField.rightView?.isHidden = true
  }
}

extension EnterRoomCodeViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
