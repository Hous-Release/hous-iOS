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
  typealias Reactor = CreateNewRoomViewReactor

  var disposeBag = DisposeBag()
  var mainView = EnterRoomTextFieldView(roomType: .new)

  override func loadView() {
    super.loadView()
    view = mainView
  }

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    setup()
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    mainView.textField.endEditing(true)
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
  private func bindAction(_ reactor: Reactor) {

    mainView.textField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .map { Reactor.Action.enterRoomName($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.enterRoomButton.rx.tap
      .map { Reactor.Action.tapCreateRoom(reactor.currentState.roomName) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindStatus(_ reactor: Reactor) {

    reactor.state.map { $0.roomNameCount }
      .bind(to: mainView.textField.countLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isButtonEnable }
      .asDriver(onErrorJustReturn: false)
      .drive(mainView.enterRoomButton.rx.isEnabled)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isErrorMessageHidden }
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: true)
      .drive(mainView.errorLabel.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state.map { $0.errorMessage }
      .compactMap{ $0 }
      .asDriver(onErrorJustReturn: "")
      .drive(mainView.errorLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$enterNewRoomFlag)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: enterNewRoom)
      .disposed(by: disposeBag)
  }
}

extension CreateNewRoomViewController {
  private func enterNewRoom(_ flag: Bool) {
    let tvc = HousTabbarViewController()
    tvc.firstCreatedSubject.onNext(true)
    changeRootViewController(to: tvc)
  }
}

extension CreateNewRoomViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }
  
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
