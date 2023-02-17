//
//  LoadingView.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2023/02/17.
//

import Lottie
import UIKit

final class LoadingView: UIView {

  private let loadingLottie: AnimationView = {
    let view = AnimationView(name: "loading")
    view.loopMode = .loop
    view.play()
    return view
  }()

  init() {
    super.init(frame: .zero)
    self.backgroundColor = Colors.black.color.withAlphaComponent(0.7)

    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  private func setupView() {
    self.addSubView(loadingLottie)
    loadingLottie.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(200)
    }
  }

  func startAnimating() {
    loadingLottie.play()
  }

  func stopAnimating() {
    loadingLottie.stop()
  }
}
