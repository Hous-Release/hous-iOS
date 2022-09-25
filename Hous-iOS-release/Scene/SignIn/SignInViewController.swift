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

  private var applegsdg = PublishRelay<String>()
  private var appleLoginManager = AppleOAuthManager()

  private let appleLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("애플로그인", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    return button
  }()

  private let kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setTitle("카카오로그인", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    return button
  }()



  override func viewDidLoad() {
    super.viewDidLoad()
    appleLoginManager.configure(in: self)
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

  private func didTapApple() {

    appleLoginManager.onSuccess = { [weak self] identifyToken, accessToken in

      self?.applegsdg.accept(identifyToken)

    }

    appleLoginManager.onFailure = { [weak self] error in

    }
  }
}
