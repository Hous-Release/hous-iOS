//
//  EnterRoomViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit
import RxCocoa
import ReactorKit

class EnterRoomViewController: UIViewController {

  var mainView = EnterRoomView()
  var disposeBag = DisposeBag()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
