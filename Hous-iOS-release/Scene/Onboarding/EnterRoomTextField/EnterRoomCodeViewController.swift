//
//  EnterRoomCodeViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit
import RxCocoa
import ReactorKit

final class EnterRoomCodeViewController: UIViewController, View {

  var disposeBag = DisposeBag()
  var mainView = EnterRoomTextFieldView(roomType: .exist)

  override func loadView() {
    super.loadView()
    view = mainView
    reactor = EnterRoomCodeViewReactor()
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

  func bind(reactor: EnterRoomCodeViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension EnterRoomCodeViewController {
  private func bindAction(_ reactor: EnterRoomCodeViewReactor) {
    mainView.textField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .map { Reactor.Action.enterRoomCode($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.enterRoomButton.rx.tap
      .map { Reactor.Action.tapEnterRoom }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: EnterRoomCodeViewReactor) {
    reactor.state.map { !$0.isValidCode }
      .bind(to: mainView.errorLabel.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isButtonEnable }
      .bind(to: mainView.enterRoomButton.rx.isEnabled)
      .disposed(by: disposeBag)

    reactor.state.map { $0.viewTransition }
      .subscribe(onNext: { isTapped in
        if isTapped {
          // 뷰전환
        }
      })
      .disposed(by: disposeBag)
  }
}

extension EnterRoomCodeViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }
  
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
