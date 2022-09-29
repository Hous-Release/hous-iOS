//
//  CreateNewRoomViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit
import RxCocoa
import ReactorKit

final class CreateNewRoomViewController: UIViewController, View {

  var disposeBag = DisposeBag()
  var mainView = EnterRoomTextFieldView(roomType: .new)

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor = CreateNewRoomViewReactor()
    setup()
  }

  private func setup() {
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
  }

  func bind(reactor: CreateNewRoomViewReactor) {
    bindAction(reactor)
    bindStatus(reactor)
  }
}

extension CreateNewRoomViewController {
  private func bindAction(_ reactor: CreateNewRoomViewReactor) {

  }

  private func bindStatus(_ reactor: CreateNewRoomViewReactor) {

  }
}

extension CreateNewRoomViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
