//
//  SignInViewController.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/25.
//

import Foundation
import UIKit
import RxRelay

final class SignInViewController: UIViewController {

  private struct Constant {
    static let horizontalMargin: CGFloat = 24
    static let buttonHegiht: CGFloat = 44
  }

  private var signInRelay = PublishRelay<(String?, Error?)>()

  private var appleLoginManager = AppleOAuthManager()

  private let kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오톡으로 계속하기", for: .normal)
    button.setTitleColor(Colors.yellow.color, for: .normal)

    return button
  }()

  private let appleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("애플로그인", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    return button
  }()



  override func viewDidLoad() {
    super.viewDidLoad()
    configureAppleSignIn()

  }

  private func setupViews() {
    view.addSubView(appleLoginButton)
    view.addSubView(kakaoLoginButton)

    appleLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.centerY.equalToSuperview()
    }
    appleLoginButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(50)
      make.centerY.equalToSuperview()
    }
  }

  private func bind() {

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
}
