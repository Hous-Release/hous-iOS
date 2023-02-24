//
//  EnterRoomViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit
import RxCocoa
import RxGesture
import ReactorKit

class EnterRoomViewController: UIViewController, View {

  var mainView = EnterRoomView()
  var disposeBag = DisposeBag()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor = EnterRoomViewReactor()
    configUI()
  }

  private func configUI() {
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: EnterRoomViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension EnterRoomViewController {
  private func bindAction(_ reactor: EnterRoomViewReactor) {
    mainView.newRoomView.rx.tapGesture()
      .when(.recognized)
      .map { _ in Reactor.Action.didTapNewRoomButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.existRoomView.rx.tapGesture()
      .when(.recognized)
      .map { _ in Reactor.Action.didTapExistRoomButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.navigationBarView.rightButton.rx.tap
      .asDriver()
      .drive(onNext: transferToSettingView)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: EnterRoomViewReactor) {
    reactor.state.map { $0.newRoomTransition }
      .withUnretained(self)
      .subscribe (onNext: { owner, isTapped in
        if isTapped {
          let serviceProvider = ServiceProvider()
          let reactor = CreateNewRoomViewReactor(provider: serviceProvider)
          let vc = CreateNewRoomViewController(reactor)
          owner.mainView.newRoomView.animateClick {
            owner.navigationController?.pushViewController(vc, animated: true)
          }
        }
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.existRoomTransition }
      .withUnretained(self)
      .subscribe (onNext: { owner, isTapped in
        if isTapped {
          let serviceProvider = ServiceProvider()
          let reactor = EnterRoomCodeViewReactor(provider: serviceProvider)
          let vc = EnterRoomCodeViewController(reactor)
          owner.mainView.existRoomView.animateClick {
            owner.navigationController?.pushViewController(vc, animated: true)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}

extension EnterRoomViewController {
  private func transferToSettingView() {
      let destinationViewController = ProfileSettingViewController(isInRoom: false)
      destinationViewController.view.backgroundColor = Colors.white.color
      navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
