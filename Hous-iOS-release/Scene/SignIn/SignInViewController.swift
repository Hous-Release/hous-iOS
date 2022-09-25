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
  }

  private var signInRelay = PublishRelay<(String?, Error?)>()

  private let appleLoginManager = AppleOAuthManager()
  private let kakaoLoginManager = KakaoOAuthManager()

  private lazy var kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오톡으로 계속하기", for: .normal)
    button.setTitleColor(Colors.yellow.color, for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    button.titleLabel?.textAlignment = .center

    return button
  }()

  private let appleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("애플로그인", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 16)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  internal var disposeBag = DisposeBag()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor

    configureAppleSignIn()
    configureKakaoSignIn()

    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setupViews() {
    view.addSubView(appleLoginButton)
    view.addSubView(kakaoLoginButton)

    appleLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHegiht)
      make.centerY.equalToSuperview()
    }

    kakaoLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(Constant.horizontalMargin)
      make.height.equalTo(Constant.buttonHegiht)
      make.top.equalTo(appleLoginButton.snp.bottom).offset(20)
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
  }

  private func bindDidTapKakaoAction(_ reactor: Reactor) {
    kakaoLoginButton.rx.tap
      .map { _ in Reactor.Action.didTapSignIn(.Kakao)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  private func bindDidTapAppleAction(_ reactor: Reactor) {
    kakaoLoginButton.rx.tap
      .map { _ in Reactor.Action.didTapSignIn(.Apple)}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

}

// MARK: - Bind State

extension SignInViewController {
  func bindState(_ reactor: Reactor) {
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
