//
//  SignInViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class SignInViewController: UIViewController {

  private struct Constant {
    static let horizontalMargin: CGFloat = 24
    static let buttonHegiht: CGFloat = 44
  }

  private var signInRelay = PublishRelay<(String?, Error?)>()

  private let appleLoginManager = AppleOAuthManager()
  private let kakaoLoginManager = KakaoOAuthManager()

  private let kakaoLoginButton: UIButton = {
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

  private let disposeBag = DisposeBag()



  override func viewDidLoad() {
    super.viewDidLoad()
    configureAppleSignIn()
    configureKakaoSignIn()

    setupViews()

    bind()

  }

  private func setupViews() {
    view.addSubView(appleLoginButton)
    view.addSubView(kakaoLoginButton)

    appleLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.centerY.equalToSuperview()
    }

    kakaoLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.top.equalTo(appleLoginButton.snp.bottom).offset(20)
    }
  }

  private func bind() {
    kakaoLoginButton.rx.tap.map { _ in }
      .map { self.kakaoLoginManager.login() }
      .subscribe(onNext: {
      })
      .disposed(by: disposeBag)

    signInRelay
      .subscribe(onNext: {
        print($0)
    })
      .disposed(by: disposeBag)

  }

}

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
