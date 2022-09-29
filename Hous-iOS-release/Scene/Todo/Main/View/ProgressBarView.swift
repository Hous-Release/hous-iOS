//
//  ProgressBarView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit

import SnapKit
import Then

enum ProgressType {
  case none, underHalf, overHalf, done

  var text: String {
    switch self {
    case .none:
      return "아직 하나도 못했어요!"
    case .underHalf, .overHalf:
      return "잘하고 있어요!"
    case .done:
      return "오늘 to-do 끝~!"
    }
  }

  var image: UIImage {
    switch self {
    case .none:
      return Images.profileGreen.image
    case .underHalf, .overHalf:
      return Images.profileBlue.image
    case .done:
      return Images.profilePurple.image
    }
  }
}

final class ProgressBarView: UIView {

  var progressType: ProgressType = .none {
    didSet {
      // int도 받아와야지 멍청아
    }
  }

  var progressBubbleView = ProgressBubbleView()

  private var progressImageView = UIImageView().then {
    $0.image = Images.profilePurple.image
  }

  var progressView = UIProgressView().then {
    $0.progressTintColor = Colors.blue.color
    $0.trackTintColor = Colors.blueL2.color
    $0.progressViewStyle = .default
    $0.layer.cornerRadius = 8
    $0.progress = 0.5
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    addSubViews([progressBubbleView, progressImageView, progressView])

    progressBubbleView.snp.makeConstraints { make in
      make.centerY.equalTo(progressImageView.snp.centerY)
      make.height.equalTo(29)
      make.width.equalTo(138)
      make.leading.greaterThanOrEqualTo(self.snp.leading).offset(24)
    }

    progressImageView.snp.makeConstraints { make in
      make.leading.equalTo(progressBubbleView.snp.trailing).offset(6)
      make.size.equalTo(40)
      make.centerX.equalToSuperview()
    }

    progressView.snp.makeConstraints { make in
      make.top.equalTo(progressImageView.snp.bottom).offset(12)
      make.height.equalTo(8)
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().inset(12)
    }
  }

  private func setup() {

  }
}
