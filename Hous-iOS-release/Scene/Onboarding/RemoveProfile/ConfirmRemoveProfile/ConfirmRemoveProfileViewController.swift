//
//  ConfirmRemoveProfileViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/22.
//

import UIKit
import Then

import HousUIComponent

final class ConfirmRemoveProfileViewController: UIViewController {

  var mainView = ConfirmRemoveProfileView()

  override func loadView() {
    self.view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    self.view.backgroundColor = Colors.white.color
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBarView.delegate = self
  }
}

extension ConfirmRemoveProfileViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
