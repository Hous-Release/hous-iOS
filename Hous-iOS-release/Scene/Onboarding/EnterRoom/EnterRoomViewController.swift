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
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: EnterRoomViewReactor) {
    bindAction(reactor)
    bindStatus(reactor)
  }
}

extension EnterRoomViewController {
  private func bindAction(_ reactor: EnterRoomViewReactor) {
    mainView.newRoomView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .map { _ in Reactor.Action.didTapNewRoomButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.existRoomView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .map { _ in Reactor.Action.didTapExistRoomButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindStatus(_ reactor: EnterRoomViewReactor) {
    reactor.state.map { $0.newRoomTransition }
      .subscribe (onNext: { [weak self] isTapped in
        if isTapped {
          let vc = CreateNewRoomViewController()
          self?.mainView.newRoomView.animateClick {
            self?.navigationController?.pushViewController(vc, animated: true)
          }
        }
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.existRoomTransition }
      .subscribe (onNext: { [weak self] isTapped in
        if isTapped {
          let vc = EnterRoomCodeViewController()
          self?.mainView.existRoomView.animateClick {
            self?.navigationController?.pushViewController(vc, animated: true)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}
