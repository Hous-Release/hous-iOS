//
//  EnterInfoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

import RxCocoa
import ReactorKit

class EnterInfoViewController: UIViewController, View {
  typealias Reactor = EnterInfoViewReactor

  var disposeBag = DisposeBag()
  let mainView = EnterInfoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
  }

  func bind(reactor: EnterInfoViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension EnterInfoViewController {
  private func bindAction(_ reactor: EnterInfoViewReactor) {
    mainView.nicknameTextfield.rx.text
      .orEmpty
      .distinctUntilChanged()
      .map { Reactor.Action.enterNickname($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.datePicker.rx.date
      .skip(1)
      .map { Reactor.Action.enterBirthday($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.checkBirthDayButton.rx.tap
      .map { Reactor.Action.checkBirthdayPublic(
        !self.mainView.checkBirthDayButton.isSelected) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.nextButton.rx.tap
      .map { Reactor.Action.tapNext }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: EnterInfoViewReactor) {

    reactor.state.map { $0.nickname }
      .asDriver(onErrorJustReturn: "")
      .drive(mainView.nicknameTextfield.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isBirthdayPublic }
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { !$0 }
      .bind(to: mainView.checkBirthDayButton.rx.isSelected)
      .disposed(by: disposeBag)

    reactor.state.map { $0.birthday }
      .distinctUntilChanged()
      .bind(to: mainView.birthdayTextfield.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isNextButtonEnable }
      .distinctUntilChanged()
      .bind(to: mainView.nextButton.rx.isEnabled)
      .disposed(by: disposeBag)

    reactor.state.map { $0.nextFlag }
      .distinctUntilChanged()
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: transferToEnterRoom)
      .disposed(by: disposeBag)
  }
}

extension EnterInfoViewController {
  private func transferToEnterRoom(_ isSuccess: Bool) {
    guard isSuccess else { return }
    let enterRoomVC = EnterRoomViewController()
    changeRootViewController(to: UINavigationController(rootViewController: enterRoomVC))
  }
}

extension EnterInfoViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
