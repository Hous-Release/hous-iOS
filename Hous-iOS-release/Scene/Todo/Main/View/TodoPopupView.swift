//
//  TodoPopupView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/16.
//

import UIKit

import SnapKit
import Then


class TriangleView: UIView {

  override func draw(_ rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: self.frame.width / 2, y: 0))
    path.addLine(to: CGPoint(x: 0, y: self.frame.height))
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
    path.close()
    Colors.blue.color.set()
    path.fill()
  }
}

class TodoPopupView: UIView {

  enum Size {
    static let bubbleWidth: CGFloat = 144
    static let bubbleHeight: CGFloat = 174
    static let quarterWidthOfBubble: CGFloat = bubbleWidth * 0.25
  }

  var buttonPoint: CGPoint = CGPoint(x: 0, y: 0) {
    didSet {
      bubbleView.snp.remakeConstraints { make in
        make.centerX.equalTo(buttonPoint.x - Size.quarterWidthOfBubble)
        make.centerY.equalTo(buttonPoint.y + 30)
      }
    }
  }

  let bubbleView = UIView()
  let triangleView = TriangleView()
  private let rectangleView = UIView()

  private let emptyGuideView = UIView()
  private let fullGuideView = UIView()
  private let fullCheckGuideView = UIView()

  private let verticalStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.spacing = 12
  }

  private let guideLabel = UILabel().then {
    $0.text = "to-do 상태 가이드"
    $0.font = Fonts.Montserrat.medium.font(size: 14)
    $0.textColor = Colors.white.color
  }

  private let emptyImageView = UIImageView().then {
    $0.image = Images.icNoInfo.image
  }
  private let emptyGuideLabel = UILabel().then {
    $0.text = "완료되지 않음"
  }

  private let fullImageView = UIImageView().then {
    $0.image = Images.icHalfDoneInfo.image
  }
  private let fullGuideLabel = UILabel().then {
    $0.text = "1명 이상 완료"
  }

  private let fullCheckImageView = UIImageView().then {
    $0.image = Images.icDoneInfo.image
  }
  private let fullCheckGuideLabel = UILabel().then {
    $0.text = "모두 완료"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setUp()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {
    backgroundColor = .clear

    [emptyGuideLabel, fullGuideLabel, fullCheckGuideLabel].forEach {
      $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)
      $0.textColor = Colors.white.color
    }

    triangleView.layer.opacity = 0.8
    triangleView.backgroundColor = .clear

    rectangleView.layer.opacity = 0.8
    rectangleView.layer.backgroundColor = Colors.blue.color.cgColor
    rectangleView.makeRounded(cornerRadius: 8)
  }

  private func render() {

    addSubview(bubbleView)
    [triangleView, rectangleView].forEach { bubbleView.addSubview($0) }
    [guideLabel, verticalStackView].forEach { rectangleView.addSubview($0) }
    [emptyGuideView, fullGuideView, fullCheckGuideView].forEach { verticalStackView.addArrangedSubview($0) }
    [emptyImageView, emptyGuideLabel].forEach { emptyGuideView.addSubview($0) }
    [fullImageView, fullGuideLabel].forEach { fullGuideView.addSubview($0) }
    [fullCheckImageView, fullCheckGuideLabel].forEach { fullCheckGuideView.addSubview($0) }

    bubbleView.snp.makeConstraints { make in
      make.height.equalTo(174)
      make.width.equalTo(144)
    }

    triangleView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.size.equalTo(14)
      make.centerX.equalTo(rectangleView.snp.centerX).multipliedBy(1.5)
    }

    rectangleView.snp.makeConstraints { make in
      make.top.equalTo(triangleView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    guideLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(12)
      make.leading.trailing.equalToSuperview().inset(18)
    }

    verticalStackView.snp.makeConstraints { make in
      make.top.equalTo(guideLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(18)
      make.bottom.equalToSuperview().inset(20)
    }

    [emptyImageView, fullImageView, fullCheckImageView].forEach { imageView in
      imageView.snp.makeConstraints { make in
        make.top.leading.bottom.equalToSuperview()
        make.size.equalTo(20)
      }
    }

    emptyGuideLabel.snp.makeConstraints { make in
      make.leading.equalTo(emptyImageView.snp.trailing).offset(8)
      make.centerY.equalTo(emptyImageView.snp.centerY)
      make.trailing.equalToSuperview()
    }

    fullGuideLabel.snp.makeConstraints { make in
      make.leading.equalTo(fullImageView.snp.trailing).offset(8)
      make.centerY.equalTo(fullImageView.snp.centerY)
      make.trailing.equalToSuperview()
    }

    fullCheckGuideLabel.snp.makeConstraints { make in
      make.leading.equalTo(fullCheckImageView.snp.trailing).offset(8)
      make.centerY.equalTo(fullCheckImageView.snp.centerY)
      make.trailing.equalToSuperview()
    }
  }
}
