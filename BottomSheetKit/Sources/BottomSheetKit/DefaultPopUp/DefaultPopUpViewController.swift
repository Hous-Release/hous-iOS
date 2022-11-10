//
//  File.swift
//  
//
//  Created by 김호세 on 2022/10/30.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

internal final class DefaultPopUpViewController: UIViewController {

  private enum Constant {
    static let horizontalMargin: CGFloat = 40
    static let height: CGFloat = 180
  }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.7)
    return view
  }()

  private var defaultPopUpView: DefaultPopUpView
  private var popUpAction: PopUpAction

  private let disposeBag = DisposeBag()


  init(popUpAction: DefaultPopUpAction) {

    self.popUpAction = popUpAction
    self.defaultPopUpView = popUpAction.view

    super.init(nibName: nil, bundle: nil)

    setupViews()
    bind()

  }

  required init?(coder: NSCoder) {
    fatalError("DefaultPopUpViewController is Not implemented")
  }

  private func bind() {
    defaultPopUpView.actionButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: self.sendAction)
      .disposed(by: disposeBag)

    defaultPopUpView.cancelButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: self.cancel)
      .disposed(by: disposeBag)
  }


  private func setupViews() {

    view.addSubview(rootView)

    rootView.addSubview(defaultPopUpView)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    defaultPopUpView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)

    }
  }

}

extension DefaultPopUpViewController {
  func sendAction() {
    popUpAction.sendAction()
    self.dismiss(animated: true)
  }
  func cancel() {
    popUpAction.cancel()
    self.dismiss(animated: true)
  }
}

