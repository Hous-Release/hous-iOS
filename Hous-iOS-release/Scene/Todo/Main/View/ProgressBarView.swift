//
//  ProgressBarView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/29.
//

import UIKit

import SnapKit
import Then

public enum ProgressType {
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

  enum Size {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let progressBarPadding: CGFloat = 24
  }

  var isTodoEmpty: Bool = true { // 엠티 레이블 숨기기, progressbar remove from superview
    didSet {
      if isTodoEmpty {
        [leftBubbleView, rightBubbleView, progressImageView].forEach { $0.isHidden = true }
        self.backgroundColor = Colors.blueL2.color
        self.emptyGuideLabel.isHidden = false
      } else {
        [leftBubbleView, rightBubbleView, progressImageView].forEach { $0.isHidden = false }
        self.backgroundColor = Colors.white.color
        self.emptyGuideLabel.isHidden = true
      }
    }
  }

  var progressType: ProgressType = .none {
    didSet {
      progressImageView.image = progressType.image
      switch progressType {
      case .none, .underHalf:
        leftBubbleView.isHidden = true
        rightBubbleView.isHidden = false
        rightBubbleView.guideLabel.text = progressType.text
      case .overHalf, .done:
        rightBubbleView.isHidden = true
        leftBubbleView.isHidden = false
        leftBubbleView.guideLabel.text = progressType.text
      }
    }
  }

  var progress: Float = 0 {
    didSet {
      progressView.progress = progress
      progressImageView.snp.remakeConstraints { make in
        make.leading.equalTo(leftBubbleView.snp.trailing).offset(6)
        make.trailing.equalTo(rightBubbleView.snp.leading).offset(-6)
        make.size.equalTo(40)
        switch progressType {
        case .none, .underHalf:
          make.centerX.equalTo(locateImage(with: progress) + 10)
        case .overHalf, .done:
          make.centerX.equalTo(locateImage(with: progress) - 10)
        }
      }
    }
  }

  var emptyGuideLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g5.color
    $0.text = "아직 완료할 to-do가 없어요!"
  }
  var leftBubbleView = ProgressBubbleView(bubbleViewType: .left)
  var rightBubbleView = ProgressBubbleView(bubbleViewType: .right)

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
    setup()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    makeRounded(cornerRadius: 8)
  }

  private func render() {
    addSubViews([emptyGuideLabel, leftBubbleView, rightBubbleView, progressImageView, progressView])

    emptyGuideLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    leftBubbleView.snp.makeConstraints { make in
      make.centerY.equalTo(progressImageView.snp.centerY)
      make.height.equalTo(29)
      make.width.lessThanOrEqualTo(138)
    }

    rightBubbleView.snp.makeConstraints { make in
      make.centerY.equalTo(progressImageView.snp.centerY)
      make.height.equalTo(29)
      make.width.lessThanOrEqualTo(138)
    }

    progressView.snp.makeConstraints { make in
      make.top.equalTo(progressImageView.snp.bottom).offset(12)
      make.height.equalTo(8)
      make.leading.trailing.equalToSuperview().inset(12)
      make.bottom.equalToSuperview().inset(12)
    }
  }
}

extension ProgressBarView {
  private func locateImage(with progress: Float) -> CGFloat {
    let progressBarWidth = Size.screenWidth - Size.progressBarPadding * 2
    let progressFloat: CGFloat = progressBarWidth * CGFloat(progress)
    return Size.progressBarPadding + progressFloat
  }
}
