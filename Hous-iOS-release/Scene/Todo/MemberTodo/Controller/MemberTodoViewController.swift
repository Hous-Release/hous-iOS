//
//  MemberTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/22.
//

import UIKit

import ReactorKit

class MemberTodoViewController: UIViewController {

  var mainView = MemberTodoView()

  override func loadView() {
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
