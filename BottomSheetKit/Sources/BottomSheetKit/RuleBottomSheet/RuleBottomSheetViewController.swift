//
//  RuleBottomSheetViewController.swift
//  
//
//  Created by 김민재 on 2023/05/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RuleBottomSheetViewController: UIViewController {

    private let backgroundView: UIView = {
      let view = UIView()
      view.backgroundColor = .black.withAlphaComponent(0.5)
      return view
    }()

    private let bottomSheetView: RuleBottomSheetView

    private let action: RuleBottomSheetAction

    private let disposeBag = DisposeBag()

    init(action: RuleBottomSheetAction) {
        self.action = action
        self.bottomSheetView = action.view
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTapGesture()
        setPanGesture()
        bind()
    }

}

// MARK: Gesture Animation Helper

extension RuleBottomSheetViewController {
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    private func setPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        bottomSheetView.addGestureRecognizer(panGesture)
    }

    @objc
    private func handleTap() {
        sendDismissAction(.cancel)
    }

    @objc
    private func handlePan(_ sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: bottomSheetView)
        switch sender.state {
        case .changed:
            if viewTranslation.y > 0 {
                updateBottomSheetTop(self.bottomSheetView.frame.height - viewTranslation.y)
                view.layoutIfNeeded()
            }
        case .ended:
            if viewTranslation.y < bottomSheetView.frame.height / 2 {
                self.updateBottomSheetTop(self.bottomSheetView.frame.height)
                self.view.layoutIfNeeded()
                break
            }
            sendDismissAction(.cancel)
        default:
            break
        }

    }

    func showBottomSheetWithAnimation() {
        self.updateBottomSheetTop(self.bottomSheetView.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    private func hideBottomSheetWithAnimation() {
        self.updateBottomSheetTop(0)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    private func sendDismissAction(_ action: DidBottomSheetActionType) {
        hideBottomSheetWithAnimation()
        switch action {
        case .add:
            break
        case .modify:
            self.action.sendAction(.modify)
        case .delete:
            self.action.sendAction(.delete)
        case .cancel:
            self.action.cancel()
        }

    }
}



// MARK: Layout

extension RuleBottomSheetViewController {
    private func setLayout() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(bottomSheetView)

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bottomSheetView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    func updateBottomSheetTop(_ top: CGFloat) {
        bottomSheetView.snp.updateConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).inset(top)
        }
    }

}

extension RuleBottomSheetViewController {
    private func bind() {
        bottomSheetView.modifyButton.rx.tap
          .asDriver(onErrorJustReturn: ())
          .map { DidBottomSheetActionType.modify }
          .drive(onNext: self.sendDismissAction)
          .disposed(by: disposeBag)

        bottomSheetView.deleteButton.rx.tap
          .asDriver(onErrorJustReturn: ())
          .map { DidBottomSheetActionType.delete }
          .drive(onNext: self.sendDismissAction)
          .disposed(by: disposeBag)
    }

}
