//
//  LoadingBaseViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/16.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {

  private let loadingBackgroundView = UIView().then {
    $0.isHidden = true
    $0.backgroundColor = Colors.black.color.withAlphaComponent(0.7)
  }

  private let loadingLottie = AnimationView(name: "loading").then {
    $0.loopMode = .loop
    $0.play()
  }


  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configLoadingLayout()
  }

  func showLoading() {
    DispatchQueue.main.async {
      self.view.bringSubviewToFront(self.loadingBackgroundView)
      self.loadingLottie.play()
      self.loadingBackgroundView.isHidden = false
    }
  }

  func hideLoading() {
    DispatchQueue.main.async {
      self.loadingBackgroundView.isHidden = true
    }
  }

  private func configLoadingLayout() {
    view.addSubview(loadingBackgroundView)

    loadingBackgroundView.addSubview(loadingLottie)

    loadingBackgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    loadingLottie.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(200)
    }
  }
}
