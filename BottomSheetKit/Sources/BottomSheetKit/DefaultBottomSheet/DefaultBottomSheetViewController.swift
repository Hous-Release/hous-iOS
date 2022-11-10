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

  private enum Constant {
    static let dismissPoint: CGFloat = 100
  }

  private let rootView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.7)
    return view
  }()

  private var bottomSheetView: DefaultBottomSheetView
  private var action: BottomSheetAction
  private let disposeBag = DisposeBag()
  private var initialFrame: CGRect?

  init(action: DefaultBottomSheetAction) {

    self.action = action
    self.bottomSheetView = action.view

    super.init(nibName: nil, bundle: nil)

    setupViews()
    applyPanGesture()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("DefaultPopUpViewController is Not implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    caculatePosition(bottomSheetView)
  }

  private func applyPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    bottomSheetView.addGestureRecognizer(panGesture)
  }

  @objc
  private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view).y

    switch gesture.state {

    case .changed:

      if translation > .zero {
        updateBottomLayout(translation)
        view.layoutIfNeeded()
      }
    case .ended:

      if translation <= Constant.dismissPoint {
        updateBottomLayout(0)
        view.layoutIfNeeded()
      }

      else if translation > Constant.dismissPoint {
        animateDismissView(.cancel)
      }

    default:
      break
    }
  }
  private func setupViews() {
    view.addSubview(rootView)
    rootView.addSubview(bottomSheetView)
    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    bottomSheetView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(0)
    }
  }

  private func caculatePosition(_ view: UIView) {
    guard initialFrame == nil else {
      return
    }
    self.initialFrame = CGRect(
      x: view.frame.origin.x,
      y: view.frame.origin.y,
      width: view.frame.width,
      height: view.frame.height
    )
  }
  private func updateBottomLayout(
    _ offset: CGFloat
  ) {
    bottomSheetView.snp.updateConstraints { make in
      make.bottom.equalToSuperview().offset(offset)
    }
  }

  private func animateDismissView(_ action: DidBottomSheetActionType) {
    guard let initialFrame = initialFrame else {
      return
    }
    updateBottomLayout(initialFrame.height)

    let hideAndDismiss = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
      self.view.layoutIfNeeded()
    })

    hideAndDismiss.addCompletion( { [weak self] position in
      if position == .end {
        switch action {
        case .add:
          self?.sendAction(.add)
        case .modify:
          self?.sendAction(.modify)
        case .delete:
          self?.sendAction(.delete)
        case .cancel:
          self?.cancel()
        }
      }
      self?.dismiss(animated: true)
    })
    hideAndDismiss.startAnimation()
  }

  private func bind() {

    bottomSheetView.addButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .map { DidBottomSheetActionType.add }
      .drive(onNext: self.animateDismissView)
      .disposed(by: disposeBag)

    bottomSheetView.modifyButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .map { DidBottomSheetActionType.modify }
      .drive(onNext: self.animateDismissView)
      .disposed(by: disposeBag)

    bottomSheetView.deleteButton.rx.tap
      .asDriver(onErrorJustReturn: ())
      .map { DidBottomSheetActionType.delete }
      .drive(onNext: self.animateDismissView)
      .disposed(by: disposeBag)
  }

}

extension DefaultBottomSheetViewController {
  private func sendAction(_ action: DidBottomSheetActionType) {
    self.action.sendAction(action)
  }
  private func cancel() {
    self.action.cancel()
  }
}

