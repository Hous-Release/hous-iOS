//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

internal final class CopyCodePopUpViewController: UIViewController {

  private enum Constant {
    static let width: CGFloat = 272
    static let height: CGFloat = 368
  }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.7)
    return view
  }()

  private var popUpView: CopyCodePopUpView
  private var popUpAction: CopyCodePopUpAction

  private let disposeBag = DisposeBag()


  init(popUpAction: CopyCodePopUpAction) {

    self.popUpAction = popUpAction
    self.popUpView = popUpAction.view

    super.init(nibName: nil, bundle: nil)

    setupViews()
    bind()

  }

  required init?(coder: NSCoder) {
    fatalError("DefaultPopUpViewController is Not implemented")
  }

  private func bind() {
    popUpView.actionButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: self.sendAction)
      .disposed(by: disposeBag)

    popUpView.cancelButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: self.cancel)
      .disposed(by: disposeBag)
  }


  private func setupViews() {

    view.addSubview(rootView)

    rootView.addSubview(popUpView)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    popUpView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.height.equalTo(Constant.height)
      make.width.equalTo(Constant.width)
    }
  }

}

extension CopyCodePopUpViewController {
  func sendAction() {
    popUpAction.sendAction()
  }
  func cancel() {
    popUpAction.cancel()
  }
}
