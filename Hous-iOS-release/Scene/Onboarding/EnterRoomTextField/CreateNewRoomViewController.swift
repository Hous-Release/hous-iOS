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
    mainView.textField.rx.text
      .orEmpty
      .map { Reactor.Action.enterRoomName($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.enterRoomButton.rx.tap
      .map { Reactor.Action.tapCreateRoom }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindStatus(_ reactor: CreateNewRoomViewReactor) {
    reactor.state.map { $0.roomName }
      .bind(to: mainView.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.roomNameCount }
      .bind(to: mainView.textField.countLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isButtonEnable }
      .bind(to: mainView.enterRoomButton.rx.isEnabled )
      .disposed(by: disposeBag)

    reactor.state.map { $0.viewTransition }
      .subscribe(onNext: { isTapped in
        if isTapped {
          // 뷰 전환
        }
      })
      .disposed(by: disposeBag)
  }
}

extension CreateNewRoomViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
