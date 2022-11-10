//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

internal final class DefaultBottomSheetViewController: UIViewController {

  private enum Constant { }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.7)
    return view
  }()

  private var bottomSheetView: DefaultBottomSheetView
  private var action: BottomSheetAction

  private let disposeBag = DisposeBag()


  init(action: DefaultBottomSheetAction) {

    self.action = action
    self.bottomSheetView = action.view

    super.init(nibName: nil, bundle: nil)

    setupViews()
//    bind()

  }

  required init?(coder: NSCoder) {
    fatalError("DefaultPopUpViewController is Not implemented")
  }

  private func setupViews() {

    view.addSubview(rootView)

    rootView.addSubview(bottomSheetView)

    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    bottomSheetView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

//  private func bind() {
//    bottomSheetView.actionButton.rx.tap
//      .asDriver(onErrorJustReturn: ())
//      .drive(onNext: self.sendAction)
//      .disposed(by: disposeBag)
//
//    bottomSheetView.cancelButton.rx.tap
//      .asDriver(onErrorJustReturn: ())
//      .drive(onNext: self.cancel)
//      .disposed(by: disposeBag)
//  }

}



//extension DefaultBottomSheetViewController {
//  func sendAction() {
//    popUpAction.sendAction()
//  }
//  func cancel() {
//    popUpAction.cancel()
//  }
//}
//
