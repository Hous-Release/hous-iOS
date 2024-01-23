//
//  SplashViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

import Alamofire
import BottomSheetKit
import Lottie
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol SplashViewControllerDelegate: AnyObject {
  func transferForSuccess(_ isJoiningRoom: Bool)
  func transferOnboarding(_ isOnboardingFlow: Bool)
  func transferLogin(_ isLoginFlow: Bool)
}

final class SplashViewController: UIViewController, ReactorKit.View {

  weak var delegate: SplashViewControllerDelegate? // coordinator라고도 씀. 근데 사실상 Delegate pattern

  private let lottieView: AnimationView = {
    let view = AnimationView(name: "splashlottie")
    view.contentMode = .scaleAspectFit
    return view
  }()

  typealias Reactor = SplashReactor
  internal var disposeBag = DisposeBag()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    setupViews()
    self.reactor = reactor

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    lottieView.play()
  }

  private func setupViews() {
    view.addSubView(lottieView)

    lottieView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalToSuperview()
    }
  }

  func transferForSuccess(_ isJoiningRoom: Bool) {
    delegate?.transferForSuccess(isJoiningRoom)
  }

  func transferOnboarding(_ isOnboardingFlow: Bool) {
    delegate?.transferOnboarding(isOnboardingFlow)
  }

  func transferLogin(_ isLoginFlow: Bool) {
    delegate?.transferLogin(isLoginFlow)
  }
}

extension SplashViewController {
  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }

  func bindAction(_ reactor: Reactor) {
    bindViewWillAppearAction(reactor)
  }

  func bindState(_ reactor: Reactor) {
    bindIsJoiningRoomState(reactor)
    bindIsLoginFlowState(reactor)
    bindIsOnboardingFlowState(reactor)
    bindShwoAlertByServerErrorFlagState(reactor)
  }

}

extension SplashViewController {
  func bindViewWillAppearAction(_ reactor: Reactor) {
    rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .delay(.seconds(2), scheduler: MainScheduler.instance)
      .map { _ in Reactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

extension SplashViewController {
  func bindIsJoiningRoomState(_ reactor: Reactor) {
    reactor.state.map(\.isJoiningRoom)
      .compactMap { $0 }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: self.transferForSuccess)
      .disposed(by: disposeBag)
  }

  func bindIsOnboardingFlowState(_ reactor: Reactor) {
    reactor.state.map(\.isOnboardingFlow)
      .compactMap { $0 }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: self.transferOnboarding)
      .disposed(by: disposeBag)
  }
  func bindIsLoginFlowState(_ reactor: Reactor) {
    reactor.state.map(\.isLoginFlow)
      .compactMap { $0 }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: self.transferLogin)
      .disposed(by: disposeBag)
  }
  func bindShwoAlertByServerErrorFlagState(_ reactor: Reactor) {
    reactor.state.map(\.shwoAlertByServerErrorMessage)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.handleError)
      .disposed(by: disposeBag)
  }
}

  // MARK: - Method
extension SplashViewController: ErrorHandler {
  func handleError(_ error: HouseErrorModel?) {
    guard
      let model = error,
      let status = model.status,
      let message = model.message

    else { return }

    if status == 426 {
      let imagePopUpModel = ImagePopUpModel(
        image: .needUpdate,
        actionText: "좋아요!",
        text: "새로운 Hous-가 나왔어요!\nHous-와 함께 즐거운\n공동생활을 계속해 봐요!",
        titleText: "업데이가 필요해요!"
      )

      let type = PopUpType.needUpdate(imagePopUpModel)
      presentPopUp(type) { action in
        switch action {
        case .action:
          if let url = URL(string: "itms-apps://itunes.apple.com/app/id1659976144") {
            UIApplication.shared.open(url)
          }
        case .cancel:
          return
        }
      }
    } else {
      Toast.show(message: message, controller: self)
    }
  }
}
