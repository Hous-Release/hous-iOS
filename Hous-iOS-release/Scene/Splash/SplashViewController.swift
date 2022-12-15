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

final class SplashViewController: UIViewController, ReactorKit.View {


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

  override func viewDidLoad() {
    super.viewDidLoad()
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
    
    let tvc = HousTabbarViewController()
    
    let enterRoomVC = EnterRoomViewController()

    if isJoiningRoom {
      changeRootViewController(to: tvc)
      return
    }

    if !isJoiningRoom {
      changeRootViewController(to: UINavigationController(rootViewController: enterRoomVC))
      return
    }

  }

  func transferOnboarding(_ isOnboardingFlow: Bool) {
    guard isOnboardingFlow else { return }

    let onboardingVC = PagingViewController()
    changeRootViewController(to: onboardingVC)
  }

  func transferLogin(_ isLoginFlow: Bool) {
    guard isLoginFlow else { return }

    let serviceProvider = ServiceProvider()
    let reactor = SignInReactor(provider: serviceProvider)
    let loginVC = SignInViewController(reactor)
    changeRootViewController(to: UINavigationController(rootViewController: loginVC))
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
      .delay(.seconds(3), scheduler: MainScheduler.instance)
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
      .drive(onNext: self.showError)
      .disposed(by: disposeBag)
  }
}

  // MARK: - Method
extension SplashViewController {
  func showError(_ model: HouseErrorModel?) {
    guard
      let model = model,
      let status = model.status,
      let message = model.message
    else { return }

    if status == 426 {
      let imagePopUpModel = ImagePopUpModel(
        image: .needUpdate,
        actionText: "좋아요!",
        text: "새로운 Hous-가 나왔어요!\nHous-와 함께 즐거운\n공동생활을 계속해 봐요!",
        titleText: "업데이트 해주세요!"
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
    }

    else {
      Toast.show(message: message, controller: self)
    }
  }
}
