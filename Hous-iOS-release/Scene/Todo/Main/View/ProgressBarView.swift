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
}

final class ProgressBarView: UIView {

  enum Size {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let progressBarPadding: CGFloat = 24
  }

  var isTodoEmpty: Bool = true {
    didSet {
      if isTodoEmpty {
        [leftBubbleView, rightBubbleView, progressImageView].forEach { $0.isHidden = true }
        self.backgroundColor = Colors.blueL2.color
        self.emptyGuideLabel.isHidden = false
      } else {
        self.progressImageView.isHidden = false
        self.backgroundColor = Colors.white.color
        self.emptyGuideLabel.isHidden = true
      }
    }
  }

  var progressType: ProgressType = .none {
    didSet {
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
      progressView.progress = progress / 100
      animateProgress(progress)
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
    $0.image = Images.icProgressbar.image
  }

  var progressView = UIProgressView().then {
    $0.progressTintColor = Colors.blue.color
    $0.trackTintColor = Colors.blueL2.color
    $0.progressViewStyle = .default
    $0.layer.cornerRadius = 8
    $0.progress = 0.0
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
    [emptyGuideLabel, leftBubbleView, rightBubbleView, progressImageView].forEach { $0.isHidden = true }
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

    progressImageView.snp.makeConstraints { make in
      make.leading.equalTo(leftBubbleView.snp.trailing).offset(6)
      make.trailing.equalTo(rightBubbleView.snp.leading).offset(-6)
      make.width.equalTo(84)
      make.centerX.equalTo(locateImage(with: 0))
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
    let progressFloat: CGFloat = progressBarWidth * CGFloat(progress/100)
    return Size.progressBarPadding / 2 + progressFloat
  }

  func animateProgress(_ progress: Float) {
    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
      self.progressImageView.snp.updateConstraints { make in
        switch self.progressType {
        case .none, .underHalf:
          let offset = CGFloat(42 - 0.84 * self.progress)
          make.centerX.equalTo(self.locateImage(with: self.progress) + offset)

        case .overHalf, .done:
          let offset = CGFloat(42 - 0.84 * (100 - self.progress))
          make.centerX.equalTo(self.locateImage(with: self.progress) - offset)
        }
      }
      self.progressImageView.superview?.layoutIfNeeded()
    })
  }
}
