//
//  SignInViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class SignInViewController: UIViewController, ReactorKit.View {
  typealias Reactor = SignInReactor

  private struct Constant {
    static let horizontalMargin: CGFloat = 24
    static let buttonHegiht: CGFloat = 44
    static let bottomMargin: CGFloat = 32
  }

  private let backgroudImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    imageView.image = Images.bg.image
    return imageView
  }()

  private lazy var kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오톡으로 계속하기", for: .normal)
    button.backgroundColor = Colors.kakaoYellow.color
    button.setTitleColor(Colors.kakaoBrown.color, for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    button.titleLabel?.textAlignment = .center
    button.makeRounded(cornerRadius: 8)

    return button
  }()

  private let appleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("애플로그인", for: .normal)
    button.backgroundColor = Colors.black.color
    button.setTitleColor(Colors.white.color, for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    button.titleLabel?.textAlignment = .center
    button.makeRounded(cornerRadius: 8)

    return button
  }()


  private let appleLoginManager = AppleOAuthManager()
  private let kakaoLoginManager = KakaoOAuthManager()
  private var signInRelay = PublishRelay<(String?, Error?)>()
  internal var disposeBag = DisposeBag()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    configureAppleSignIn()
    configureKakaoSignIn()
    setupViews()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setupViews() {

    view.addSubView(backgroudImageView)
    backgroudImageView.addSubView(appleLoginButton)
    backgroudImageView.addSubView(kakaoLoginButton)

    backgroudImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    appleLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHegiht)
      make.bottom.equalToSuperview().inset(Constant.bottomMargin)
    }

    kakaoLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHegiht)
      make.bottom.equalTo(appleLoginButton.snp.top).offset(-Constant.horizontalMargin)
    }
  }

}

  // MARK: - Bind Reactor
extension SignInViewController {

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}


// MARK: - Bind Action
extension SignInViewController {

  func bindAction(_ reactor: Reactor) {
    bindDidTapKakaoAction(reactor)
    bindDidTapAppleAction(reactor)
    bindOAuthAction(reactor)
  }

  private func bindDidTapKakaoAction(_ reactor: Reactor) {
    kakaoLoginButton.rx.tap
      .map { _ in Reactor.Action.didTapSignIn(.Kakao)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  private func bindDidTapAppleAction(_ reactor: Reactor) {
    appleLoginButton.rx.tap
      .map { _ in Reactor.Action.didTapSignIn(.Apple)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  private func bindOAuthAction(_ reactor: Reactor) {
    signInRelay
      .map { Reactor.Action.login(accessToken: $0.0, error: $0.1) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

}

// MARK: - Bind State

extension SignInViewController {
  func bindState(_ reactor: Reactor) {
    bindSignInTypeState(reactor)
    bindErrorState(reactor)
    bindIsJoiningState(reactor)
    bindEnterInfoState(reactor)
  }

  func bindSignInTypeState(_ reactor: Reactor) {
    reactor.state.map(\.signinType)
      .distinctUntilChanged()
      .filter { $0 != nil }
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: login)
      .disposed(by: disposeBag)
  }
  func bindErrorState(_ reactor: Reactor) {
    reactor.state.map(\.error)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: self.handlingError)
      .disposed(by: disposeBag)
  }
  func bindIsJoiningState(_ reactor: Reactor) {
    reactor.state.map(\.isJoingingRoom)
      .distinctUntilChanged()
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: self.transferForSuccess)
      .disposed(by: disposeBag)
  }
  func bindEnterInfoState(_ reactor: Reactor) {
    reactor.state.map(\.enterInformationFlag)
      .distinctUntilChanged()
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: self.transferToEnterInformation)
      .disposed(by: disposeBag)
  }
}

// MARK: Method Helper
extension SignInViewController {
  private func login(_ signInType: SignInType?) {

    guard let signInType = signInType else {
      return
    }

    switch signInType {

    case .Apple:
      appleLoginManager.login()

    case .Kakao:
      kakaoLoginManager.login()

    }
  }

  // TODO: Error PopupView로 추후 체인지

  private func handlingError(_ errorMessage: String?) {
    guard let errorMessage = errorMessage else {
      return
    }

    debugPrint(errorMessage)
    self.reactor?.action.onNext(.initial)
  }


  private func transferForSuccess(_ isJoiningRoom: Bool) {

    let homeVC = MainHomeViewController(viewModel: MainHomeViewModel())
    let enterRoomVC = EnterRoomViewController()

    if isJoiningRoom {
      changeRootViewController(to: homeVC)
      return
    }

    if !isJoiningRoom {
      reactor?.action.onNext(.initial)
      navigationController?.pushViewController(enterRoomVC, animated: true)
      return
    }

  }

  private func transferToEnterInformation(_ isSuccess: Bool) {
    guard isSuccess else { return }
    guard let signinType = reactor?.currentState.signinType,
          let oAuthToken = reactor?.currentState.oauthToken else { return }
    reactor?.action.onNext(.initial)

    let serviceProvider = ServiceProvider()

    let enterInfoReactor = EnterInfoViewReactor(
      provider: serviceProvider,
      signinType: signinType,
      oAuthToken: oAuthToken)

    let enterInfoVC = EnterInfoViewController(enterInfoReactor)
    navigationController?.pushViewController(enterInfoVC, animated: true)
  }
}

  // MARK: - OAuth Method
extension SignInViewController {

  private func configureAppleSignIn() {

    appleLoginManager.configure(in: self)

    appleLoginManager.onSuccess = { [weak self] identifyToken, accessToken in
      self?.signInRelay.accept((identifyToken, nil))
    }

    appleLoginManager.onFailure = { [weak self] error in
      self?.signInRelay.accept((nil, error))
    }
  }

  private func configureKakaoSignIn() {

    kakaoLoginManager.configure(appKey: "23a6d7ad94f44f0e474ee41b4e6d9fab")

    kakaoLoginManager.onSuccess = { [weak self] identifyToken, _ in
      self?.signInRelay.accept((identifyToken, nil))
    }

    kakaoLoginManager.onFailure = { [weak self] error in
      self?.signInRelay.accept((nil, error))
    }
  }

}
