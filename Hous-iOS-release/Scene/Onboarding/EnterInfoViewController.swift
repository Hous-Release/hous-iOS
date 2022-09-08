//
//  EnterInfoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

import RxSwift

class EnterInfoViewController: UIViewController {

  let mainView = EnterInfoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

}
